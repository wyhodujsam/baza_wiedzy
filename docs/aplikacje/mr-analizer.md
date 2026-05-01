# MR Analizer

> **TL;DR:** Aplikacja webowa analizująca Pull Requesty (GitHub + GitLab) pod kątem automatyzacji przez LLM. Scoring regułami (exclude/boost/penalize), wymienne adaptery LLM (Claude CLI, Anthropic API, OpenAI API, LLM Proxy), dashboard React z wykresami, analiza projektowa, dashboard aktywności kontrybutora i drzewo struktury organizacyjnej.

## Stack

| Komponent | Technologia |
|-----------|-------------|
| Backend | Java 17, Spring Boot 3.2, Maven |
| Frontend | React 18, TypeScript, Vite 6, React-Bootstrap, Chart.js |
| Baza danych | H2 (file-based, `data/mranalizer`) |
| Architektura | Heksagonalna (ports & adapters) |
| Testy backend | Cucumber 7 (BDD), JUnit 5, Mockito (641 testów) |
| Testy frontend | Vitest + React Testing Library (214 testów), Playwright (E2E) |
| Quality | PMD, SpotBugs (`pmd-rules.xml`, `spotbugs-exclude.xml`) |
| Metodologia | SDD (Spec Kit) + BDD |

## Porty

| Serwis | Port |
|--------|------|
| Backend (Spring Boot REST API) | 8083 |
| Frontend (Vite dev server) | 3000 |

## Repozytorium

- GitHub: [wyhodujsam/mr-analizer](https://github.com/wyhodujsam/mr-analizer)
- Lokalnie: `~/apps/mr_analizer`

## Uruchomienie

```bash
export GITHUB_TOKEN=ghp_...

# Backend
cd ~/apps/mr_analizer/backend
mvn spring-boot:run

# Frontend
cd ~/apps/mr_analizer/frontend
npx vite --host 0.0.0.0 --port 3000
```

Alias: `mra-restart` (w ~/.bashrc)

## Funkcje

### Analiza PR (główny moduł)

- **Przeglądanie MR/PR** — lista PR z GitHub/GitLab bez scoringu, z checkboxami do selekcji
- **Quick Analyze MR** — wklejasz pełny link do MR/PR, system parsuje URL (`MrUrlParser`) i analizuje pojedynczy PR
- **Asynchroniczna analiza** — `POST /api/analysis` zwraca **202 ACCEPTED** z raportem `IN_PROGRESS`; per-MR scoring i LLM dzieją się w tle, klient pollluje GET aż status = `COMPLETED`/`FAILED`
- **Scoring regułami** — exclude/boost/penalize z konfigurowalnymi wagami
- **Verdicts** — AUTOMATABLE / MAYBE / NOT_SUITABLE z kolorowym badge
- **Score breakdown** — szczegóły które reguły zadziałały
- **Multi-LLM** — wymienne adaptery: Claude CLI, Anthropic API, OpenAI API, LLM Proxy (np. `bazooka-cloud-h2m.llm-proxy-prod-1.corpnet.pl` z modelem Claude). Wybór przez `application.yml` (`llm.provider`)
- **Tracking kosztów LLM** — per analiza (`LlmCost`)
- **Zapisane repozytoria** — dropdown z historią repo, GitHub/GitLab dropdown przy dodawaniu
- **Historia analiz** — per PR (tytuł, autor, score), filtr po repo / werdykcie / zespole / obszarze
- **Wykres kołowy** — podsumowanie verdictów
- **Cache browse** — cachowanie listy PR z przyciskiem odświeżania
- **Persystencja** — H2 file-based, dane przetrwają restart

### Analiza projektu (`/project`)

Agreguje wyniki analiz na poziomie projektu:

- **Project Analysis** — uruchomienie analizy całego repo z konfigurowalnym promptem
- **Persystencja** — `JpaProjectAnalysisRepository` zapisuje wyniki per projekt
- **Tabela PR-ów** — zestawienie z wynikiem AI score, verdict, ruleResults i komentarzem LLM
- **Unified Scoring** — single-MR i project analysis zwracają identyczne wyniki dla tego samego PR-a

### Aktywność kontrybutora (`/activity`)

Dashboard analizy aktywności użytkownika lub całego zespołu w repozytorium:

- **Mode toggle** — Kontrybutor (per login) vs Cały zespół (po strukturze org)
- **6+ reguł wykrywania** (Strategy pattern): za duże PR, szybki review, praca weekendowa/nocna/Friday afternoon, brak review, self-merge, hotfix PR, draft/WIP merged, time-to-first-review, review iterations
- **Heatmapa aktywności** — SVG grid w stylu GitHub (13 tygodni, 5 poziomów koloru, tooltip, drill-down)
- **Bar chart aktywności** — z linią trendu
- **Klikalne badge severity** — filtrowanie tabeli flag
- **Statystyki** — średni rozmiar PR, czas review, % pracy weekendowej, churn, impact, cycle time, velocity, merge ratio
- **Multi-repo support** — agregacja po wielu repozytoriach
- **Snapshoty kontrybutorów** — `JpaContributorSnapshotRepository` (TTL 15 min, refresh manualny)
- Route: `/activity`, osobne API: `/api/activity/{owner}/{repo}/...`

### Struktura organizacji (`/org`)

Drzewo Department → Team → Contributor:

- **OrgNode** — DEPARTMENT, TEAM, CONTRIBUTOR types
- **Membership** — przypisanie loginu do zespołu
- **Filtrowanie analiz** — werdykt per zespół/obszar/cały dział (przez `scopeNodeId` w `FetchCriteria`)
- Persystencja: `JpaContributorOrgRepository`, `OrgNodeEntity`, `ContributorMembershipEntity`

### Diagnostics

- `DiagnosticsController` + `SqlStatsResponse` — statystyki SQL/cache (do debug)

## Architektura heksagonalna

```
domain/          # Czysta logika (0 zależności): modele (project/, activity/), reguły, scoring, porty in/out (project/, activity/)
application/     # Use cases: AnalyzeMrService (async), GetAnalysisResultsService, ContributorOrgService
adapter/in/rest/ # REST API (Spring controllers) — w tym podpakiety activity/, project/
adapter/out/     # GitHub (WebClient + reviews), GitLab, LLM (Claude CLI, Anthropic, OpenAI, Proxy), JPA (H2)
```

Wymienne adaptery przez porty:

- `MergeRequestProvider` — GitHub, GitLab
- `LlmAnalyzer` — `ClaudeCliAdapter`, `AnthropicApiAdapter`, `OpenAiApiAdapter`, `LlmProxyAdapter`
- `ReviewProvider` — `GitHubReviewAdapter`
- `ProjectAnalysisRepository`, `ContributorOrgRepository`, `ContributorSnapshotRepository` — JPA + InMemory

## Testy

- **855 testów** (641 backend + 214 frontend), 0 failures
- Backend: 173 scenariusze BDD Cucumber w 25 plikach `.feature` + JUnit 5 + Mockito
- Frontend: Vitest + RTL (unit), Playwright (E2E w `frontend/e2e/`)
- Stan WIP (`@wip`): 26 scenariuszy oczekujących implementacji (np. `analyze-mr-by-link.feature` jako spec frontend-flow, incremental refresh w `activity-cache`)
