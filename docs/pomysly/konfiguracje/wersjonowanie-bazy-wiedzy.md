# Wersjonowanie bazy wiedzy w prywatnym repo GitHub

**Status:** :white_check_mark: Zrealizowane (2026-03-19)

**TL;DR:** Zainicjować repozytorium Git w `~/mkdocs-kb` i pushować do prywatnego repo na GitHub. Zabezpieczenie przed utratą danych + historia zmian.

## Motywacja

Baza wiedzy (`~/mkdocs-kb/docs/`) rośnie i zawiera coraz więcej wartościowych notatek. Utrata tego katalogu (awaria dysku, błąd użytkownika) oznaczałaby stratę zgromadzonej wiedzy. Git + GitHub daje backup offsite i pełną historię zmian.

## Realizacja

- Repo: [github.com/wyhodujsam/baza_wiedzy](https://github.com/wyhodujsam/baza_wiedzy) (prywatne)
- `.gitignore` wyklucza `site/`, `__pycache__/`, `.venv/`, `.cache/`
- Commitowane są docs, `mkdocs.yml` i `overrides/`
- Cron codziennie o 22:00 uruchamia `auto-commit.sh` — skrypt commituje zmiany (jeśli są) i pushuje do GitHub
