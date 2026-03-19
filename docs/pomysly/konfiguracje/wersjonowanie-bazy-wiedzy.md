# Wersjonowanie bazy wiedzy w prywatnym repo GitHub

**TL;DR:** Zainicjować repozytorium Git w `~/mkdocs-kb` i pushować do prywatnego repo na GitHub. Zabezpieczenie przed utratą danych + historia zmian.

## Motywacja

Baza wiedzy (`~/mkdocs-kb/docs/`) rośnie i zawiera coraz więcej wartościowych notatek. Utrata tego katalogu (awaria dysku, błąd użytkownika) oznaczałaby stratę zgromadzonej wiedzy. Git + GitHub daje backup offsite i pełną historię zmian.

## Plan

1. `git init` w `~/mkdocs-kb`
2. Dodać `.gitignore` (np. `site/`, `__pycache__/`, `.venv/`)
3. Utworzyć prywatne repo na GitHub (`gh repo create mkdocs-kb --private`)
4. Pierwszy commit i push
5. Opcjonalnie — hook lub cron robiący auto-commit + push np. raz dziennie

## Uwagi

- Repo **musi** być prywatne — baza zawiera notatki osobiste
- Rozważyć czy commitować też `mkdocs.yml` i pliki konfiguracyjne (raczej tak)
- Auto-push można zrobić prostym skryptem w cronie albo hookiem w Claude Code
