# Głęboka integracja graphify z workflow GSD

## TL;DR

Graphify istnieje w GSD jako **standalone skill** (`/gsd-graphify build|query|status|diff`), ale żaden inny workflow nie konsumuje grafu. Pomysł: wpiąć knowledge graph w kluczowe punkty SDD (plan-phase, execute-phase, debug, code-review, audit-milestone) jako automatyczne źródło kontekstu — zamiast trzymać go jako "narzędzie do recznego zapytania".

## Stan obecny (2026-05-19)

### Co graphify już robi

Skill `~/.claude/skills/gsd-graphify/SKILL.md`:

- Buduje `.planning/graphs/graph.json` z nodów (encje), edges (relacje), hyperedges
- Klasy pewności: `EXTRACTED` / `INFERRED` / `AMBIGUOUS`
- SHA256 incremental caching → szybkie rebuild
- Output: `graph.json`, `graph.html` (wizualizacja D3), `GRAPH_REPORT.md`
- Operacje: `build`, `query <term>`, `status`, `diff` (vs poprzedni snapshot)
- Gate przez `.planning/config.json` → `graphify.enabled = true`

### Co inne workflowy GSD robią

| Workflow | Kontekst który zbiera | Czy używa grafu? |
|----------|----------------------|------------------|
| `gsd-discuss-phase` | pyta usera + czyta `.planning/intel/` | NIE |
| `gsd-plan-phase` | research + pattern-mapper + planner | NIE |
| `gsd-execute-phase` | PLAN.md + deviation handling | NIE |
| `gsd-debug` | hipotezy + logi + grep | NIE |
| `gsd-code-review` | git diff + REVIEW.md | NIE |
| `gsd-audit-milestone` | wszystkie artefakty fazowe | NIE |
| `gsd-ai-integration-phase` | research domeny + frameworków | NIE |

**Wniosek**: graf jest "trzymany w szufladzie" — zbudowany, ale wykorzystywany tylko gdy człowiek ręcznie zapyta `/gsd-graphify query foo`. Nikt nie sprawdza go automatycznie.

## Pomysł: integration points

### 1. Plan-phase: graph-driven blast radius

Przed planowaniem fazy `gsd-pattern-mapper` (już istnieje) dostaje też wynik `graphify query <feature>`. Wynik: PLAN.md zna wszystkie nody dotknięte tym obszarem zanim planner zacznie pisać taski.

**Wartość**: planner nie zapomina o ukrytych zależnościach (np. że `OrderService` jest też wołany przez `BatchExporter`, którego nikt nie widzi przeszukując nazwami).

**Koszt**: jeden dodatkowy node call w preflight (< 2s przy ciepłym cache'u).

### 2. Execute-phase: deviation z kontekstem grafu

Gdy executor chce zmodyfikować plik spoza PLAN.md (deviation), przed checkpointem pyta graf: "kto jeszcze zależy od tego node'a?". Wynik trafia do prompta deviation.

**Wartość**: zamiast pytać usera "czy mogę dotknąć X?" — przedstawia *konsekwencje* dotknięcia X (3 inne fazy, 7 testów, 1 zewnętrzny endpoint).

### 3. Debug: graf jako pierwsza hipoteza

`gsd-debug` zaczyna każdą sesję od `graphify query <symptom>`. Wynik = lista podejrzanych nodów posortowana po `confidence`. To **zastępuje pierwszy etap** (ręczne grepowanie i czytanie plików), nie dodaje pracy.

**Wartość**: szybsze konwergowanie do root cause. Zamiast 5 iteracji eksploracji — 1 query + 2 weryfikacje.

### 4. Code-review: diff vs graph

`gsd-code-review` po git diff woła `graphify diff` (snapshot przed/po fazie). Reviewer dostaje:

- "Faza dodała 12 nodów, usunęła 3, zmieniła 8 edges"
- Lista nowych zależności cross-module (np. domain → infra — flaga architektoniczna)
- Lista nodów które przestały być osiągalne (martwy kod?)

**Wartość**: review widzi *architektoniczne* skutki zmiany, nie tylko linie kodu.

### 5. Audit-milestone: graf historii kamieni milowych

Przy zamykaniu kamienia milowego porównanie snapshotów grafów z początku i końca. Output:

- Co kamień dodał strukturalnie (nowe moduły, integracje)
- Co usunął
- Wzrost coupling/cohesion (metryki nad grafem)
- Realna złożoność vs deklarowana w PROJECT.md

### 6. Auto-build po execute-phase

Po każdym `gsd-execute-phase` (lub przynajmniej po `gsd-complete-milestone`) — hook automatycznie woła `graphify build`. Graf nigdy się nie starze.

Alternatywa: hook na post-commit (config-gate'owany).

### 7. AI-integration-phase: graf jako kontekst RAG dla evals

Gdy `gsd-ai-integration-phase` generuje eval dataset, może użyć grafu jako źródła "ground truth structure" — np. dla RAG nad kodebazą, evals dotyczące architektury (czy LLM rozumie strukturę projektu).

## Ranking wartość / koszt

| Integration point | Wartość | Złożoność | Priorytet |
|-------------------|---------|-----------|-----------|
| Debug — graf jako 1. hipoteza | **wysoka** | niska | **MVP** |
| Plan-phase — blast radius | wysoka | niska | **MVP** |
| Auto-build hook | średnia | bardzo niska | **MVP** |
| Code-review — diff grafu | wysoka | średnia | high |
| Execute deviation z kontekstem | średnia | średnia | medium |
| Audit-milestone snapshot diff | średnia | wysoka (metryki nad grafem) | low |
| AI-integration RAG ground truth | spec. | wysoka | low |

## MVP — minimalna integracja

3 punkty na start, wszystkie behind config flag `graphify.deep_integration = true`:

1. **`gsd-debug` preamble** — przed Step 1 (hipoteza) wywołaj `graphify query <user_symptom_keywords>` jeśli graf istnieje. Wynik wstrzyknij do prompta debuggera.
2. **`gsd-plan-phase` pattern-mapper** — dodaj graphify query do bagażu kontekstowego.
3. **Post-execute hook** — w `bin/gsd-tools.cjs` po sukcesie `execute-phase` woła `graphify build` w tle (background task), jeśli włączone.

Każdy z tych punktów to ~50-100 LOC zmian w odpowiednich workflow plików w `~/.claude/get-shit-done/workflows/`.

## Otwarte pytania

- **Stale graph penalty**: co robić gdy graf jest STALE (np. > 7 dni od ostatniego buildu)? Auto-rebuild blokujący? Warning bez blokady? Skip integracji?
- **Cost w tokenach**: każde query to dodatkowy kontekst do prompta. Czy obcinać top-N najtrafniejszych nodów? Jak limity?
- **Confidence floor**: czy używać tylko `EXTRACTED` (twarde fakty AST) czy też `INFERRED` / `AMBIGUOUS` (heurystyka)?
- **Multi-language**: jak graphify radzi sobie z Java + React mono-repo (jak mr_analizer)? Jeden graf czy dwa?

## Następne kroki

- [ ] Włączyć graphify w jednym projekcie (mr_analizer) i ocenić jakość grafu
- [ ] Zmierzyć: ile nodów, ile edges, jaki % `EXTRACTED` vs `INFERRED`
- [ ] Spróbować ręcznie zrobić plan-phase z grafem vs bez i porównać PLAN.md
- [ ] Spike: hook post-execute → `graphify build`
- [ ] Jeśli ROI dodatni → PR do upstream GSD (jeśli to nie jest fork) lub fork-only zmiany w `~/.claude/get-shit-done/`

## Powiązane

- [Generowanie dokumentacji bez LLM](doc-gen-bez-llm.md) — graphify jako alternatywa / komplement dla wskazanych tam parserów (Pyreverse, Dependency Cruiser)
- [Skill Tester](skill-tester.md) — można by testować czy skille GSD prawidłowo konsultują graf
