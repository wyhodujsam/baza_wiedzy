# Generowanie testów dla wyhodujSam — wnioski

> **TL;DR:** Spec Kit pozwolił ustrukturyzować pracę od specyfikacji do implementacji. Z 11 testów zrobiło się 312. Haiku generuje więcej testów szybciej i taniej, ale z większą liczbą błędów kompilacji. Model routing per task to opłacalna strategia.

## Kontekst

- **Projekt:** wyhodujSam (garden-service) — Spring Boot 2.2.6, Java 8
- **Cel:** dodanie testów jednostkowych do 14 nietestowanych serwisów
- **Framework SDD:** GitHub Spec Kit v0.3.1
- **Data:** 2026-03-19

## Przebieg workflow Spec Kit

1. `specify init . --ai claude` — scaffolding w projekcie
2. `/speckit.constitution` — constitution wygenerowany z analizy istniejącego kodu (brownfield)
3. `/speckit.specify` — specyfikacja feature'a "dodaj testy" (3 user stories: P1 krytyczne, P2 domenowe, P3 wspierające)
4. `/speckit.plan` — plan implementacji + research.md z decyzjami technicznymi
5. `/speckit.tasks` — 20 tasków rozbite na fazy
6. `/speckit.implement` — implementacja z model routing per task

## Wyniki

### Przed vs po

| Metryka | Przed | Po |
|---------|-------|----|
| Klasy testowe | 6 | 20 |
| Testy | 11 | 312 |
| Pokrycie serwisów | 1/14 (7%) | 14/14 (100%) |
| Czas testów | ~3s | ~5s |

### Benchmark model routing

Każdy task (= jeden plik testowy) był przypisany do modelu na podstawie złożoności serwisu:

| Model | Tasków | Testy | Avg czas | Avg tokeny | Błędy kompilacji |
|-------|--------|-------|----------|------------|-----------------|
| Opus | 5 | 129 | 128s | 43k | 2 (drobne) |
| Sonnet | 8 | 135 | 109s | 42k | 3 (drobne) |
| Haiku | 9 | 173 | 63s | 35k | 5 (generics, typy) |

### Szczegóły per task

| Task | Serwis | Model | Testy | Czas | Tokeny |
|------|--------|-------|-------|------|--------|
| T003 | OrderService | Opus | 16 | 109s | 37k |
| T004 | PaymentService | Sonnet | 11 | 101s | 41k |
| T005 | GardenPaymentService | Haiku | 26 | 67s | 34k |
| T006 | UserService | Opus | 42 | 127s | 33k |
| T007 | GardenService | Opus | 28 | 146s | 54k |
| T008 | PlantsService | Sonnet | 18 | 139s | 60k |
| T009 | ProductService | Haiku | 26 | 77s | 35k |
| T010 | DeliveryService | Sonnet | 24 | 150s | 53k |
| T011 | DispositionService | Haiku | 24 | 177s | 65k |
| T012 | ConsentService | Haiku | 24 | 45s | 27k |
| T013 | VoucherService | Sonnet | 11 | 80s | 34k |
| T014 | RecommendationService | Haiku | 9 | 28s | 34k |
| T015 | LocationService | Haiku | 6 | 40s | 23k |
| T016 | ResetPasswordService | Sonnet | 8 | 74s | 31k |
| T017 | UserGardenStatisticService | Haiku | 21 | 168s | 55k |

## Wnioski

### Spec Kit jako framework SDD

- **Sprawdza się dla brownfield** — constitution wygenerowany z istniejącego kodu dał solidną bazę
- **Ustrukturyzowany pipeline** (specify → plan → tasks → implement) wymusza przemyślenie zakresu przed implementacją
- **research.md** — wymuszenie udokumentowania decyzji technicznych (Mockito vs Spring, nazewnictwo testów) przed kodowaniem okazało się wartościowe
- **User stories z priorytetami** — naturalne rozbicie na MVP (P1) i incremental delivery (P2, P3)
- **Overhead** — dla prostego zadania "dodaj testy" pipeline SDD wydaje się ciężki; wartość rośnie przy bardziej złożonych feature'ach

### Model routing

- **Haiku** jest zaskakująco dobry do generowania testów — produkuje najwięcej testów, najszybciej i najtaniej
- **Haiku** generuje więcej błędów kompilacji (głównie: generics z DAO zwracającymi `List<Object>`, void methods z `when()` zamiast `doThrow()`, błędne typy pól)
- **Opus** najlepszy do złożonych serwisów (OrderService z 12 zależnościami, updateGarden z 80 liniami logiki)
- **Sonnet** to dobry kompromis — mniej błędów niż Haiku, tańszy niż Opus
- **Wniosek:** warto używać model routing, ale potrzebna jest faza naprawcza po agentach (szczególnie po Haiku)

### Problemy napotkane

1. **Mockito 2.21.0 → 3.12.4** — stara wersja nie wspierała `MockitoExtension` z JUnit 5; wymagała podbicia
2. **Java version w pom.xml** — spec-kit agent context script zmienił java.version z 8 na 17, co zepsuło Spring Boot 2.2.6
3. **Generics DAO** — `BaseDao.getAll()` zwraca `List<Object>`, co wymaga castowania `(List)` w Mockito stubbach; agenty tego nie wiedziały
4. **Polskie znaki** — Opus napisał `Ogrodek` zamiast `Ogródek` (ó z kreską) w asercji
5. **Logika odwrócona** — Haiku źle zrozumiał logikę `checkMarketingConsent` (metoda ma odwróconą semantykę: zwraca `false` gdy consent jest OK)

### Rekomendacje na przyszłość

- Dodać do promptu agenta informację o wzorcu `(List)` cast dla DAO
- Dodać do promptu informację o void methods → `doThrow()` zamiast `when().thenThrow()`
- Rozważyć fazę automatycznej naprawy kompilacji przed walidacją (agent fix po każdym US)
- Mierzyć nie tylko liczbę testów, ale też jakość asercji (Haiku generuje dużo testów, ale z prostszymi asercjami)
