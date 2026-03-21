# MR Analizer

> **TL;DR:** Aplikacja webowa analizująca Pull Requesty (GitHub) pod kątem automatyzacji przez LLM. Scoring regułami (exclude/boost/penalize), opcjonalna analiza Claude CLI, dashboard React z wykresami.

## Stack

| Komponent | Technologia |
|-----------|-------------|
| Backend | Java 17, Spring Boot 3.2, Maven |
| Frontend | React 18, TypeScript, Vite 5, React-Bootstrap, Chart.js |
| Baza danych | H2 (file-based) |
| Architektura | Heksagonalna (ports & adapters) |
| Testy | Cucumber 7 (BDD), JUnit 5, Mockito |
| Metodologia | SDD (Spec Kit) + BDD |

## Porty

| Serwis | Port |
|--------|------|
| Backend (Spring Boot REST API) | 8083 |
| Frontend (Vite dev server) | 3000 |

## Repozytorium

- GitHub: [wyhodujsam/mr-analizer](https://github.com/wyhodujsam/mr-analizer)
- Lokalnie: `~/mr_analizer`

## Uruchomienie

```bash
export GITHUB_TOKEN=ghp_...

# Backend
cd ~/mr_analizer/backend
mvn spring-boot:run

# Frontend
cd ~/mr_analizer/frontend
npx vite --host 0.0.0.0 --port 3000
```

Alias: `mra-restart` (w ~/.bashrc)

## Funkcje

- **Przeglądanie MR/PR** — lista PR z GitHub bez scoringu, z checkboxami do selekcji
- **Analiza scoring** — reguły exclude/boost/penalize z konfigurowalnymi wagami
- **Verdicts** — AUTOMATABLE / MAYBE / NOT_SUITABLE z kolorowym badge
- **Score breakdown** — szczegóły które reguły zadziałały
- **Opcjonalna analiza LLM** — Claude CLI z konfigurowalnym promptem
- **Zapisane repozytoria** — dropdown z historią repo
- **Historia analiz** — per PR (tytuł, autor, score), filtr po repo
- **Wykres kołowy** — podsumowanie verdictów
- **Cache browse** — cachowanie listy PR z przyciskiem odświeżania
- **Persystencja** — H2 file-based, dane przetrwają restart

## Architektura heksagonalna

```
domain/          # Czysta logika (0 zależności), modele, reguły, scoring, porty
application/     # Use cases, orkiestracja
adapter/in/rest/ # REST API (Spring controllers)
adapter/out/     # GitHub (WebClient), LLM (Claude CLI), JPA (H2)
```

Wymienne adaptery przez porty: MergeRequestProvider (GitHub, przyszły GitLab), LlmAnalyzer (Claude CLI, NoOp, przyszłe API).
