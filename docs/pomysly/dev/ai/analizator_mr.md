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

## Status

Pomysł — do realizacji.
