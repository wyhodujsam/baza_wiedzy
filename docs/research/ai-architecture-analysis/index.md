# AI w analizie architektonicznej i mapowaniu BL

> Research o tym, jak używać AI do analizy architektury, walidacji wymagań biznesowych (BL w Jira) i mapowania ich na komponenty/procesy. Konkretne narzędzia, frameworki, badania, plan wdrożenia dla T3.

**Data:** 2026-04-30
**Powiązane:** [Nebius](../nebius/index.md) (lokalne LLM dla compliance), [AI SDLC Metrics](../ai-sdlc-metrics/index.md)

## Dwa wymiary problemu

1. **Spójność i jakość BL w Jira** — czy historie są kompletne, niesprzeczne, mają DoR/DoD, scenariusze
2. **Mapowanie BL → architektura → kod** — które komponenty/mikroserwisy/ADR-y zmienią się przy danym BL

## Klasyczne frameworki, które AI wzmacnia

| Framework | Po co | Jak AI pomaga |
|---|---|---|
| **arc42** | szablon dokumentacji architektury (12 sekcji) | LLM generuje sekcje 5/6/8 z kodu i ADR |
| **C4 model** | 4 poziomy diagramów (Context → Container → Component → Code) | LLM generuje PlantUML/Structurizr DSL |
| **ADR** (Architecture Decision Records) | "decyzja + kontekst + alternatywy + konsekwencje" | LLM proponuje ADR, zatwierdza human |
| **BPMN** | procesy biznesowe | LLM generuje BPMN XML z opisu BL |

Rekomendacja: arc42 + ADR jako "rama" — wtedy AI ma na czym pracować.

## Skille AI — narzędzia po stronie Jira / wymagań

| Narzędzie | Co robi | Forma |
|---|---|---|
| **ScopeMaster** | 500–1000 checków/story, sizing COSMIC, one-click analiza całego backloga | Atlassian Marketplace |
| **Refinely** | Zadaje pytania uzupełniające, generuje gotowe stories | Marketplace |
| **Maister AI for Jira** | Analiza, poprawa user stories, generuje acceptance criteria | Marketplace |
| **Atlassian Intelligence** (od 2024) | "Summarize", "Improve", "Generate", semantic search | Native Jira/Confluence (Cloud) |
| **Atlassian MCP server** ([sooperset/mcp-atlassian](https://github.com/sooperset/mcp-atlassian)) | LLM (Claude/Cursor) czyta Jira live | DIY, free |

**Co konkretnie sprawdzają:**
- brakujące acceptance criteria
- niejasne sformułowania
- dependencies między ticketami
- konflikty z innymi BL
- brak NFR-ów
- brak linka do epica/initiative

## Skille AI — narzędzia po stronie kodu / architektury

| Narzędzie | Co robi |
|---|---|
| **GitHub Copilot Agents** (Project Padawan) | full PR z BL, ale architektura "vibe" — bez świadomych decyzji |
| **Cursor / Cline + project rules** | architecture skeleton z opisu, generuje C4/ADR |
| **Continue.dev z custom prompts** | open-source, podłączasz reguły arc42 |
| **Anthropic Claude + MCP** | agent z dostępem do filesystem + Jira + GitLab → cross-cutting analiza |

### ⚠ "Vibe architecting"

Badania (arXiv 2604.04990, "Architecture Without Architects") pokazują, że AI agenci podejmują decyzje architektoniczne (wybór frameworka, struktura plików, integracje) jako **efekt uboczny generowania kodu** — i nikt ich nie review'uje jako decyzje.

**Reguła:** żaden agent nie podejmuje decyzji architektonicznej bez pisanego ADR.

## GraphRAG — najmocniejszy mostek "BL ↔ kod ↔ architektura"

### Knowledge Graph Layer

**Neo4j / Memgraph + LLM extractor** buduje graf:

```
Epic ─[realizes]→ Initiative
Epic ─[contains]→ Story
Story ─[affects]→ Component
Component ─[deployed_in]→ Service
Service ─[part_of]→ System (Hybris / Symfonia 6 / MS LC)
Story ─[verified_by]→ Scenario (BDD/Gherkin)
ADR ─[constrains]→ Component
Story ─[blocks]→ Story
Story ─[depends_on]→ Story
```

Dowolne pytanie w naturalnym języku → zapytanie Cypher:

> "Które komponenty zmienią się przy realizacji EPIC-1234?"
> → 3 mikroserwisy + 2 moduły Hybris + 1 ADR do podważenia

> "Które story w sprincie nie mają scenariusza testowego?"
> → lista

> "Czy STORY-456 i STORY-789 nie modyfikują tego samego komponentu w sprzeczny sposób?"
> → konflikt

**Microsoft GraphRAG** (open-source) — gotowy framework, ale costly (10–100× droższe niż zwykłe RAG przy budowie grafu).

### MCP Layer (alternatywa lekka)

**Model Context Protocol** — standard od Anthropic (kwiecień 2025). Lokalne MCP servery:
- `mcp-atlassian` — czyta Jira/Confluence
- `mcp-gitlab` — czyta repo, MR-y
- własny `mcp-architecture` — eksponuje arc42 + C4 + ADR-y

Claude/Cursor/Cline łączy się do MCP i pyta "across" — bez budowania grafu, ale z mniejszą głębokością. Wystarczy na 80% przypadków.

## Badania naukowe

| Publikacja | Wniosek |
|---|---|
| **ProReFiCIA** (arXiv 2511.00262, 2025) | LLM generuje "impact set" (wymagania zmieniające się przy zmianie X) z prompt-refinement-filtering |
| **TraceLLM framework** (2025) | F1 traceability requirement↔code: 64–80%; precision >87%, recall 47–75% |
| **MBSE + LLM dla traceability** (SERC 2025) | RAG + LLM ustanawia linki BL ↔ artefakty z F1 ~0.75 |
| **Architecture Without Architects** (arXiv 2604.04990) | Dokumentuje "vibe architecting", wezwanie do ADR-first workflow |

### Praktyczne wnioski z badań

- **Precision wysoka, recall niski** — AI nie pominie tego co znajdzie, ale przegapi część. Używaj jako **assist**, nie autorytet.
- **GPT-4 / Claude > CodeLlama** dla NL requirements (warto zapłacić).
- **GraphRAG > vanilla RAG** dla pytań cross-cutting (multi-hop reasoning).

## Plan dla T3 — 3 horyzonty

### H1 — szybkie wygrane (1–2 tygodnie)

1. **30-day trial ScopeMaster lub Refinely** — wgraj BL z Symfonii 6, raport jakości od razu
2. **Atlassian Intelligence** — jeśli Premium: semantic search + summarize w Jira
3. **Prompt template "BL → koncepcja"** — szablon w Confluence do wklejania do Claude'a:
   - input: tekst BL
   - output: lista komponentów + brakujące AC + propozycje scenariuszy BDD

### H2 — kontekst T3 (1–3 miesiące)

1. **arc42 dla T3** — System Context, Building Blocks (Hybris + 8 mikroserwisów), 5 najważniejszych ADR
2. **MCP setup**:
   - `mcp-atlassian` na laptopach AR/PO
   - Claude Desktop / Cursor czyta Jira live
   - prompt: "Pokaż mi BL z 3 sprintów dotykające MS LC"
3. **SKILL.md w każdym repo** — opis zakresu, kluczowych klas, NFR-ów (czyta Claude/Cursor automatycznie)

### H3 — knowledge graph (3–9 miesięcy)

1. **Neo4j community / Memgraph** + extractor (LangChain LLMGraphTransformer) buduje graf nightly z Jira API + GitLab API + ADR-ów
2. **Dashboard tygodniowy**: "stories bez scenariusza", "epica blokowane", "ADR sprzeczne z nowymi BL"
3. **Pre-commit hook** — MR sprawdza w grafie czy zmienione komponenty mają linkowane stories i scenariusze

## Pułapki

1. **Halucynacje na nazwach komponentów** — LLM wymyśli "ServiceX" którego nie ma. Zawsze RAG z autorytatywnym źródłem.
2. **"Wszystko w Jira" jako pretekst do braku architektury** — AI nie zastąpi ADR.
3. **Marketplace apps są drogie przy skali** — ScopeMaster ~$5–10/user/mies. (30 osób → $150–300/mies).
4. **Atlassian Intelligence vendor lock-in** — działa tylko na Cloud, nie da się zaudytować.
5. **Knowledge graph wymaga utrzymania** — extractor LLM musi nadążać za zmianami nazewnictwa, custom fields. Nightly job + alerting.
6. **Compliance (Orange/BlueSoft)** — BL może być wrażliwe. Atlassian Cloud → poza UE? Alternatywa: lokalne LLM (Llama 3.1 70B na [Nebius](../nebius/index.md)) zamiast OpenAI/Anthropic.

## "Co dziś zrobić" — bez ryzyka i kosztów

1. **30-dniowy trial ScopeMaster** na obecnym BL Symfonii 6 — 1 dzień konfiguracji
2. **Atlassian MCP server** lokalnie + Claude Desktop — godzina setup, pytanie o BL w NL
3. **Pierwsze 5 ADR-ów dla T3** — historyczne decyzje (Hybris vs MS LC, Gherkin tylko po stronie B, warsztat 4-stronny), wg [adr.github.io](https://adr.github.io/)

## Źródła

### AI dla wymagań i traceability
- [ProReFiCIA — LLM-Driven Cost-Effective Requirements Change Impact Analysis (arXiv)](https://arxiv.org/html/2511.00262)
- [Evaluating LLMs for Documentation to Code Traceability (arXiv)](https://arxiv.org/html/2506.16440v1)
- [AI-Enhanced Requirements Traceability Using MBSE and LLM (SERC)](https://sercuarc.org/wp-content/uploads/2025/09/Legesse_AI_Enhanced_Requirements_Traceability_Using_MBSE_LLM_Complex_Systems.pdf)
- [Establishing Traceability Between NL Requirements and Software Artifacts via RAG+LLMs (ACM)](https://dl.acm.org/doi/10.1007/978-3-031-75872-0_16)
- [Enabling Architecture Traceability by LLM (Fuchss, ICSA 2025)](https://fuchss.org/assets/pdf/2025/icsa-25.pdf)

### Frameworki dokumentacji
- [arc42 documentation](https://docs.arc42.org/)
- [C4 model](https://c4model.com/)
- [ADR by Joel Parker Henderson (GitHub)](https://github.com/joelparkerhenderson/architecture-decision-record)
- [adr.github.io](https://adr.github.io/)

### Vibe architecting
- [Architecture Without Architects (arXiv 2604.04990)](https://arxiv.org/abs/2604.04990)
- [Describing Agentic AI Systems with C4 (arXiv 2603.15021)](https://arxiv.org/html/2603.15021v1)

### GraphRAG
- [Microsoft GraphRAG](https://microsoft.github.io/graphrag/)
- [Memgraph — Graph RAG](https://memgraph.com/docs/ai-ecosystem/graph-rag)
- [Neo4j — Knowledge Graph + LLM multi-hop reasoning](https://neo4j.com/blog/genai/knowledge-graph-llm-multi-hop-reasoning/)
- [IBM — Implementing Graph RAG](https://www.ibm.com/think/tutorials/knowledge-graph-rag)

### Jira / Atlassian
- [ScopeMaster — One-click backlog analysis](https://www.scopemaster.com/press-releases/one-click-backlog-analysis-for-jira-software/)
- [Refinely — Atlassian Marketplace](https://marketplace.atlassian.com/apps/3016668857/refinely-ai-backlog-refinement-for-jira)
- [Maister AI for Jira](https://marketplace.atlassian.com/apps/1224655/maister-ai-for-jira)
- [Atlassian — AI for issue analytics](https://www.atlassian.com/blog/developer/artificial-intelligence-for-issue-analytics-a-machine-learning-powered-jira-cloud-app)
- [mcp-atlassian (sooperset, GitHub)](https://github.com/sooperset/mcp-atlassian)

### MCP
- [Anthropic — Model Context Protocol](https://modelcontextprotocol.io/)
- [TechTarget — In-demand AI skills 2026 (MCP, agentic systems)](https://www.techtarget.com/searchcio/tip/In-demand-AI-skills)
