# MR Analizer UX

> **TL;DR:** Niezależny projekt redesignu UX/UI dla [mr-analizer](mr-analizer.md). Bez kodu produkcyjnego — tylko research, wireframes, prototypy, decyzje. Osobne repo, osobny kontekst Claude'a (lokalne `.claude/` + skill `ui-ux-pro-max`).

## Status

🌱 Świeżo założony (2026-05-01). Faza research jeszcze nie ruszyła.

## Lokalizacja

- Lokalnie: `~/apps/mr-analizer-ux`
- Repo: lokalne, `main`, brak remote
- Port: brak (projekt nie jest aplikacją web)

## Po co osobny projekt zamiast pracy w `mr_analizer`

- Czysty kontekst — sesja Claude'a startująca z tego katalogu nie ciągnie konwencji, skilli ani specs z `mr_analizer`
- Wolność projektowa — redesign od zera bez „uwięzienia" w obecnej implementacji (Bootstrap 5, struktura zakładek, itd.)
- Read-only spojrzenie na obecny kod — `~/apps/mr_analizer/` traktowany jako źródło wymagań, nie jako szkielet do zmiany

## Struktura katalogów

| Katalog | Zawartość |
|---|---|
| `research/` | Personas, user flows, pain points, competitive analysis |
| `wireframes/` | Lo-fi szkice (markdown + opcjonalnie obrazy) |
| `prototypes/` | Hi-fi prototypy (HTML/CSS lub kod) |
| `decisions/` | ADR-style notatki nieoczywistych wyborów |
| `.claude/skills/ui-ux-pro-max/` | Zewnętrzny skill UI/UX |

## Skill `ui-ux-pro-max`

Zainstalowany lokalnie w projekcie. Zewnętrzna baza wiedzy projektowej:

- 161 palet kolorystycznych, 57 par fontów, 50+ stylów
- 99 wytycznych UX (a11y, touch, performance, formy, animacja)
- 25 typów wykresów, 161 typów produktu z regułami doboru
- Wytyczne dla 10 stacków (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui, HTML/CSS)

Wywołanie:

```bash
cd ~/apps/mr-analizer-ux
python3 .claude/skills/ui-ux-pro-max/scripts/search.py \
  "developer tools code review dashboard" --design-system -p "mr-analizer-ux"
```

Source: <https://github.com/nextlevelbuilder/ui-ux-pro-max-skill>

## Workflow

Każdy etap (research → IA → wireframes → prototypy) kończy się dokumentem decyzji w `decisions/` z datą i uzasadnieniem. Decyzje pochodzące z `ui-ux-pro-max` cytują domain + query.

## Co NIE wchodzi w scope

- Modyfikacje kodu w `~/apps/mr_analizer/`
- Decyzje implementacyjne (framework, biblioteki) — dopiero po zaakceptowanych prototypach
