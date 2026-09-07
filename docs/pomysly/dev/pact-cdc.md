# Pact — alternatywa dla integration testów / schema testingu

## TL;DR

Pact to de facto standard Consumer-Driven Contracts. Zamiast end-to-end testów (drogie, flaky) lub OpenAPI schema validation (mówi *jak wygląda API*, nie *czego ktoś używa*) — kontrakt pisze konsument, provider weryfikuje że go nie złamał. Pomysł: przetestować Pact w projekcie z ≥3 konsumentami i ocenić czy zastąpi (lub uzupełni) obecne podejście do weryfikacji kompatybilności między usługami.

## Alternatywą dla czego konkretnie

| Obecne podejście | Co boli | Co Pact zmienia |
|------------------|---------|-----------------|
| **E2E / integration testy** | Wolne, flaky, wymagają wystawienia całego stacku, trudno utrzymać | Każda strona testuje *swoją część* w izolacji, kontrakt łączy strony |
| **OpenAPI + schema validation** (Schemathesis, Dredd) | Mówi "tak wygląda API" — nie wie kto czego używa. Usunięcie nieużywanego pola → false positive | Mówi "frontend potrzebuje X, mobile potrzebuje Y" — możesz ewoluować API bez psucia istniejących konsumentów |
| **Dokumentacja API w README / Confluence** | Rozsynchronizowuje się z kodem w 2 sprinty | Kontrakt jest wykonywalny, CI go waliduje przy każdej zmianie |
| **"Spróbujmy na stagingu i zobaczmy"** | Wykrywa break dopiero po deployu | `can-i-deploy` blokuje deploy zanim cokolwiek się stanie |

## Jak działa (skrót)

```
Consumer test → mock provider wg oczekiwań → generuje pact.json
                                                    │
                                              Pact Broker
                                                    │
Provider test ← fetch pacts ← replay każdej interakcji na realnym kodzie
                                                    │
                                              wynik weryfikacji
                                                    │
                                              can-i-deploy? → CI gate
```

Pełny opis flow + przykłady kodu w pact-jvm: zob. transkrypt z sesji 2026-05-19 (lokalizacja w sesji Claude).

## Stack — co dziś jest dojrzałe

- **pact-jvm 4.6+** — JUnit 5, Spring Boot, bindings do wspólnego rdzenia w Rust (`pact_ffi`)
- **Pact Broker** — Docker image (Ruby + Postgres), self-hosted
- **PactFlow** — SaaS, free tier dla małych zespołów (SmartBear od 2024)
- **Pact V4 + plugins** — gRPC, Avro, Protobuf, GraphQL (nie tylko HTTP)

## Kiedy ma sens — kiedy nie

**Ma sens:**

- ≥3 konsumentów per provider (np. web + mobile + B2B integracje)
- Niezależne deploymenty (klucz!) — bez tego E2E jest tańsze
- Cross-team / cross-repo
- Polyglot (mobile w Swift/Kotlin + backend w JVM)
- Mocno ewoluujące API (potrzeba kasować pola bez psucia konsumentów)

**Nie ma sensu:**

- Monorepo z joint deploy (np. mr_analizer) — integration testy wystarczą
- 1 konsument + 1 provider — koszt utrzymania brokera + state'ów > zysk
- Provider-first organizacje gdzie OpenAPI jest źródłem prawdy → bi-directional contracts lub Schemathesis
- Brak dyscypliny consumer team — jeśli konsument nie pisze kontraktu, provider nie wie o oczekiwaniach

## Pułapki które przewidzieć

1. **Matcher hell** — za luźne (`stringType()` wszędzie) nie waliduje nic; za ścisłe (`stringValue`) jest flaky. Zasada: `Type` na strukturę, `Value` tylko enumy/stałe.
2. **State management (`@State`)** to ~80% wysiłku po stronie providera — baza w żądanym stanie nie jest darmowa.
3. **Provider weryfikuje tylko to, o co konsument pyta** — pole nieobjęte żadnym kontraktem może być usunięte i Pact powie OK. CDC działa tylko gdy *wszyscy* konsumenci grają.
4. **Pact ≠ logika biznesowa** — kontrakt łapie kształt API, nie poprawność obliczeń. E2E jest dalej potrzebne (mniej).
5. **Versioning** — `consumer-app-version` musi być stabilne (SHA, nie timestamp), inaczej matrix puchnie i `can-i-deploy` zwalnia.

## Co zbadać (pomysł na eksperyment)

Najlepszy kandydat to nie mr_analizer (monorepo) — raczej **projekt klientowski z Bluesoft** gdzie są mikrousługi i niezależne deploye.

Etapy:

1. **Spike 1 — consumer test** (2-4h): pact-jvm w jednym serwisie, kontrakt na jeden endpoint, mock server lokalnie. Cel: zrozumieć matchery i `@State`.
2. **Spike 2 — provider verification** (2-4h): drugi serwis weryfikuje kontrakt. Cel: zrozumieć ile kosztuje state setup w realnym Springu z bazą.
3. **Spike 3 — broker w CI** (4-8h): Pact Broker w Dockerze, publish z CI, `can-i-deploy` jako gate przed mergem. Cel: zrozumieć friction w real workflow.
4. **Decyzja**: czy ROI uzasadnia rozszerzenie na pozostałe pary konsument↔provider, czy zostać przy integration testach.

Kluczowe metryki do zmierzenia:

- Czas dodania nowego endpointa (consumer pisze kontrakt → provider weryfikuje → deploy)
- Liczba false positive'ów (kontrakt failed, ale realnie nic się nie psuje) — duże > Pact bezuży
- Czas debugowania failed verification (jak czytelne są błędy)
- Koszt utrzymania brokera (uptime, upgrade'y, RBAC)

## Konkurencja do porównania

Jeśli eksperyment z Pact wypadnie miernie, alternatywne ścieżki:

- **Spring Cloud Contract** — lepszy dla all-Spring shopów (stub jars, lepszy IDE support), słabszy dla polyglot konsumentów
- **Schemathesis / Dredd** — jeśli OpenAPI jest źródłem prawdy i provider-first
- **Bi-directional contracts (PactFlow)** — kompromis: provider publikuje OpenAPI, consumer publikuje pact, broker statycznie porównuje. Tańsze (provider bez verification testów), słabsze (wierzy że OpenAPI mówi prawdę)
- **Schema Registry (Avro/Protobuf)** — dla async / Kafka, często wystarcza zamiast pact V4 message

## Następne kroki

- [ ] Zidentyfikować projekt-kandydat (≥3 konsumentów, niezależny deploy)
- [ ] Spike 1: pact-jvm consumer test (2-4h)
- [ ] Spike 2: provider verification z realnym Springiem (2-4h)
- [ ] Spike 3: broker w CI + can-i-deploy gate (4-8h)
- [ ] Porównanie z obecnym podejściem (czas, flaky rate, debugowalność)
- [ ] Jeśli ROI dodatni → propozycja adopcji w zespole, plan migracji

## Powiązane

- [Generowanie dokumentacji bez LLM](doc-gen-bez-llm.md) — kontrakty Pacta to wykonywalna dokumentacja API (uzupełnienie auto-gen docs)
- [Graphify ↔ GSD integration](graphify-gsd-integration.md) — graf zależności mógłby pokazywać które pary konsument↔provider istnieją (kandydaci do CDC)
