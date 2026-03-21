# Analizator MR/PR pod kątem automatyzacji przez LLM

**TL;DR:** Skrypt/aplikacja analizująca merge requesty (pull requesty) i oceniająca, które z nich mogłyby być wykonane automatycznie przez LLM — z konfigurowalnymi regułami filtrowania.

## Problem

Nie każda zmiana w kodzie nadaje się do automatyzacji przez AI. Jednoliniowe zmiany konfiguracji, ręczne bumpy wersji czy specyficzne poprawki infrastrukturowe to strata tokenów. Potrzebne jest narzędzie, które przegląda historię MR/PR i wskazuje te, które LLM mógłby wykonać samodzielnie.

## Funkcje

- **Analiza historii MR/PR** — pobieranie i parsowanie merge requestów z GitLab/GitHub
- **Klasyfikacja zmian** — ocena czy zmiana nadaje się do automatyzacji (refaktoring, dodanie testów, implementacja feature'a wg opisu)
- **Konfigurowalne reguły** — definiowanie własnych reguł decydujących o kwalifikacji MR:
    - minimalna/maksymalna liczba zmienionych plików
    - typy plików (np. ignoruj `.yaml`, `.toml` konfiguracyjne)
    - wzorce w opisie MR (np. „refactor", „add tests")
    - rozmiar diffa (za mały = nie warto, za duży = za ryzykowne)
    - obecność testów wুzmianach
    - label/tagi na MR
- **Scoring** — punktowa ocena każdego MR pod kątem potencjału automatyzacji
- **Raport** — zestawienie MR z oceną i uzasadnieniem

## Przykładowe reguły

```yaml
rules:
  exclude:
    - changed_files < 2
    - file_extensions: [".env", ".yml", ".toml"]
    - labels: ["hotfix", "security"]
  boost:
    - description_contains: ["refactor", "cleanup", "add test"]
    - has_tests: true
    - changed_files: 3-15
  penalize:
    - diff_lines > 500
    - no_description: true
```

## API — porównanie GitHub vs GitLab

Oba providery udostępniają bardzo podobne REST API, co pozwala zbudować wspólny interfejs z dwoma implementacjami.

Dostępne dane w obu: metadane (tytuł, opis, autor, status, daty), diff/zmienione pliki, komentarze, review, statusy CI, labels, assignees.

### Różnice

| Aspekt | GitHub | GitLab |
|--------|--------|--------|
| Nazwa | Pull Request | Merge Request |
| ID | `number` | `iid` |
| Komentarze | rozdzielone (issue vs review comments) | zunifikowane (`notes`) |
| Approvale | Reviews API | `/approvals` endpoint |
| Paginacja | `Link` header | `X-Next-Page` header |
| Auth | `Bearer ghp_...` | `PRIVATE-TOKEN: glpat-...` |

### Kluczowe endpointy

**GitHub:** `/repos/{owner}/{repo}/pulls`, `.../pulls/{n}/files`, `.../pulls/{n}/comments`, `.../pulls/{n}/reviews`

**GitLab:** `/api/v4/projects/:id/merge_requests`, `.../:iid/changes`, `.../:iid/notes`, `.../:iid/approvals`

### Podejście

Wspólny interfejs (np. `MergeRequestProvider`) z dwoma implementacjami mapującymi na jeden model danych. ~90% logiki analizy będzie współdzielone.

## Status

**Zrealizowany** — aplikacja działa jako [mr-analizer](../../../apps/mr-analizer.md).

- Repo: [github.com/wyhodujsam/mr-analizer](https://github.com/wyhodujsam/mr-analizer)
- Stack: Java 17 + Spring Boot 3.2 (backend), React 18 + TypeScript (frontend)
- Port: 8083 (backend), 3000 (frontend dev)
- Architektura heksagonalna, SDD + BDD (Cucumber)
- Zaimplementowane: GitHub adapter, scoring (exclude/boost/penalize), Claude CLI adapter, dashboard React z wykresami, cache, historia analiz per PR
- Do zrobienia: adapter GitLab, wykresy trendów, filtrowanie po autorze, eksport CSV/PDF, tryb CI
