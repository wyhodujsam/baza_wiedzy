# Skill Tester — testowanie skilli dla agentów AI

## TL;DR

Skrypt do weryfikacji czy skill (dokument markdown) zawiera wystarczające informacje, by model LLM poprawnie odpowiedział na zestaw pytań. Dwa tryby: generowanie odpowiedzi i porównanie semantyczne z odpowiedziami wzorcowymi.

## Pomysł

W ramach inicjatywy tworzenia dokumentacji w formacie skilli dla agentów AI potrzebujemy narzędzia do testowania jakości tych skilli. Skill to dokument opisujący jak agent ma wykonać zadanie — ale skąd wiemy, że zawiera wszystko co trzeba?

### Dwa tryby działania

#### Tryb 1: Generowanie odpowiedzi (answer mode)

```
Wejście:  skill.md + pytania.yaml
Wyjście:  odpowiedzi wygenerowane przez LLM na podstawie skilla
```

LLM dostaje skill jako kontekst i odpowiada na każde pytanie. Wynik do ręcznej inspekcji — czy skill wystarczył?

#### Tryb 2: Porównanie z wzorcem (eval mode)

```
Wejście:  skill.md + pytania.yaml + odpowiedzi_wzorcowe.yaml
Wyjście:  raport — dla każdego pytania: pass/fail + uzasadnienie
```

LLM generuje odpowiedź na podstawie skilla, potem **drugi wywołanie LLM** porównuje ją semantycznie z odpowiedzią wzorcową. Nie chodzi o identyczność tekstu — chodzi o to, czy sens się zgadza.

### Przykład

```yaml
# pytania.yaml
questions:
  - id: q1
    question: "Jaki port domyślnie używa aplikacja?"
    expected: "8083"  # tylko w eval mode
  - id: q2
    question: "Jak uruchomić testy integracyjne?"
    expected: "mvn verify -Pintegration"
  - id: q3
    question: "Jakie systemy zewnętrzne integruje aplikacja?"
    expected: "PayU, SMTP (Gmail), AWS S3"
```

### Raport z eval mode

```
q1: PASS — skill podaje port 8083 w sekcji "Uruchomienie"
q2: FAIL — skill nie wspomina o profilu Maven, odpowiedź LLM: "mvn test"
q3: PASS — skill wymienia PayU, Gmail SMTP i S3 w sekcji "Integracje"
```

## Architektura

```
┌────────────────────┐
│   CLI / Skrypt     │
│  skill-tester      │
├────────────────────┤
│  Loader            │  ← wczytuje skill.md + pytania.yaml
│  AnswerGenerator   │  ← wysyła skill + pytanie do LLM
│  SemanticComparator│  ← porównuje odpowiedź z wzorcem (LLM)
│  ReportGenerator   │  ← generuje raport pass/fail
└────────┬───────────┘
         │ API
┌────────┴───────────┐
│   Anthropic API    │
│   (Claude)         │
└────────────────────┘
```

## Stack

| Warstwa | Technologia |
|---------|-------------|
| Język | Node.js (TypeScript) |
| LLM | Anthropic SDK (`@anthropic-ai/sdk`) |
| Format pytań | YAML (`yaml` package) |
| CLI | `commander` + `chalk` |
| Build | npm / npx |

## Kluczowe decyzje projektowe

- **Dwa osobne wywołania LLM w eval mode** — jedno generuje odpowiedź z kontekstem skilla, drugie porównuje semantycznie. Rozdzielenie zapobiega bias (model nie widzi wzorca gdy odpowiada).
- **YAML na pytania** — prosty, czytelny, łatwy do edycji ręcznej.
- **CLI tool** — nie potrzebuje frontendu, ma działać w pipeline / terminalu.
- **Semantyczne porównanie** — LLM ocenia czy odpowiedź pokrywa sens wzorca, nie czy tekst jest identyczny. Zwraca PASS/FAIL + uzasadnienie.

## Następne kroki

- [ ] Napisać spec (spec-kit: specification.md)
- [ ] Zaprojektować prompty (answer prompt, comparator prompt)
- [ ] MVP: tryb answer — skill + pytania → odpowiedzi
- [ ] Dodać tryb eval — porównanie semantyczne z wzorcem
- [ ] Raport w formacie markdown
- [ ] Opcjonalnie: batch mode (testuj wiele skilli naraz)
