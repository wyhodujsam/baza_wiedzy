# Metryki sukcesu wdrożenia AI w SDLC

> Research o tym, jak mierzyć realną wartość wdrożenia AI (Copilot, Cursor, AI code review, agentic SDLC) w procesie wytwarzania oprogramowania. Realne case studies + metody pomiaru.

**Data:** 2026-04-29
**Powiązane:** [SDD research](../sdd/index.md), [Conventions experiment](../../research/index.md)

## TL;DR

- Mierz w trzech warstwach jednocześnie: **Adoption** (czy używają), **Impact** (czy daje efekt), **Cost** (vs. zaoszczędzony czas).
- Zaufaj liczbom z **DORA Report 2025**: realne zyski to **5–15%**, nie 50–100% z marketingu vendorów.
- Najważniejsza metryka jakości AI: **Defect Escape Rate (DER)** — bo "total defects" rośnie po wdrożeniu skanerów AI (więcej wykrywamy, nie znaczy że gorzej).
- **Productivity Paradox**: indywidualnie +21% tasków, ale metryki organizacyjne często stoją w miejscu.

## Trzy frameworki pomiarowe

### DORA (DevOps Research & Assessment)

4 klasyczne + 2 nowe metryki dostawy oprogramowania:

- Deployment Frequency
- Lead Time for Changes
- Change Failure Rate
- Mean Time to Recover (MTTR)
- **Rework Rate** (nowa, kluczowa dla AI)
- Reliability (quasi-metric)

**Pomiar:** dane z Git/CI/CD (GitHub Actions, GitLab, Jenkins) + system incydentów (PagerDuty, Opsgenie).

### SPACE (GitHub + Microsoft + Univ. of Victoria)

5 wymiarów odpornych na "gaming" przez AI:

- **S**atisfaction & well-being
- **P**erformance
- **A**ctivity
- **C**ommunication
- **E**fficiency / flow

**Pomiar:** ankiety (DevEx survey), telemetria IDE, analiza commitów.

### DX Core 4 (2025)

Łączy DORA + SPACE + DevEx w 4 wymiary:

| Wymiar | Co mierzy |
|--------|-----------|
| **Speed** | PR throughput, lead time, deployment frequency |
| **Effectiveness** | DXI (Developer Experience Index) — z ankiet |
| **Quality** | Change failure rate, escaped defects |
| **Impact** | % czasu na nowe funkcje vs. utrzymanie |

**Pomiar:** kombinacja telemetrii systemowej + self-reportu + experience sampling.

## Kategorie metryk z metodami weryfikacji

### A. Adopcja — czy ludzie naprawdę używają

| Metryka | Jak mierzyć | Benchmark |
|---|---|---|
| Active AI Users % | Logi licencji Copilot/Cursor (30-day active) | Cel: >70% w 6 mies. |
| AI Tool Engagement Rate | API metryk (np. GitHub Copilot Business Metrics API) | — |
| Acceptance Rate sugestii | Telemetria IDE (% zaakceptowanych) | Średnia 27–33% |
| Retention Rate kodu | "accepted-and-retained characters" — ile kodu AI zostało po 7/30 dniach | GitHub: 88% |
| Time-to-Value | Dni od licencji do pierwszego "merged PR z AI" | — |

### B. Produktywność — czy szybciej dostarczamy

| Metryka | Jak mierzyć | Realne wyniki |
|---|---|---|
| Cycle Time | Jira/GitHub: czas od "in progress" do "merged" | Harness: -3.5h, Copilot: -8% |
| PR Throughput | Liczba zmergowanych PR / inżynier / tydzień | Microsoft/Accenture: +26% tasks |
| Task Completion Speed | Eksperymenty A/B (kontrolowana grupa) | McKinsey: ~2× szybciej |
| Lead Time for Changes | DORA, GitHub API | — |

### C. Jakość — czy nie psujemy

| Metryka | Jak mierzyć | Uwagi |
|---|---|---|
| **Defect Escape Rate (DER)** | (bugi z produkcji / wszystkie bugi) × 100 | Najważniejsza dla AI |
| **Rework Rate (30-day)** | % linii zmienionych w 30 dni od merge | Człowiek: 15–20%, AI bez review: 35–40% |
| Defect Density | Bugi / KLOC | SonarQube, Codacy |
| Change Failure Rate | % deploymentów wymagających rollback/hotfix | DORA |
| Test Coverage Delta | Różnica pokrycia przed/po AI | JaCoCo, SonarQube |
| Pre-merge defects caught | Issues z review (zwłaszcza AI-review) | Wzrost = lepiej |

!!! warning "Pułapka"
    Po wdrożeniu AI-skanerów (CodeRabbit, Greptile) liczba wykrytych defektów **rośnie** — to dobrze. Patrz na DER, nie na "total defects".

### D. Business Impact / ROI

| Metryka | Wzór |
|---|---|
| AI-driven time saved | (godziny zaoszczędzone/dev/tydzień) × stawka × liczba devów |
| ROI Phase 1 | (Korzyści architektoniczne − koszt wdrożenia) / koszt |
| ROI Phase 2 | (Korzyści przyspieszenia developmentu − koszty operacyjne) / koszty |
| Cost per AI User | Łączny koszt licencji+infra / liczba aktywnych userów |
| PR Throughput Lift | Różnica PR/dev z AI vs. bez AI z **AI Attribution Factor** |

## Realne case studies

| Firma | Skala | Wynik | Co mierzyli |
|---|---|---|---|
| **Microsoft / Accenture** (badanie GitHub) | 3 firmy | +26% completed tasks, większy zysk u juniorów | Liczba zadań, ankiety |
| **ZoomInfo** | 400+ devów | Acceptance 33%, satysfakcja 72% | Telemetria + ankieta |
| **Goldman Sachs** | Tysiące devów | +20% produktywności, -15% bugów po release | Bugi prod + cycle time |
| **Booking.com** | 3500+ inżynierów | +16% throughput, jakość utrzymana | DORA + DX |
| **Harness** (klient) | 50 devów (A/B 2+2 mies.) | +10.6% PR, -3.5h cycle time | DORA |
| **McKinsey study** | Multi-firma | +16-30% time-to-market, +31-45% jakość u top performers | DORA + ankiety |

## Productivity Paradox (DORA 2025)

DORA Report 2025 pokazał:

- **Indywidualna wydajność rośnie**: +21% tasków, +98% PR
- **Metryki organizacyjne stoją w miejscu**

**Wniosek:** mierz nie tylko utilization, ale też impact i cost.

## Praktyczny stack pomiarowy

| Warstwa | Narzędzia |
|---------|-----------|
| Telemetria AI | GitHub Copilot Metrics API, Cursor Analytics, Tabnine Admin |
| DORA | Faros AI, LinearB, Jellyfish, Plandek, Sleuth, GetDX |
| Jakość | SonarQube (lokalna instancja!), Codacy, Snyk, CodeScene |
| Ankiety | DX DevEx Survey, własne (Google Forms, Typeform) co kwartał |
| Dashboard | Power BI / Grafana / własny + Worklytics dla adoption |

## Anti-patterns

1. **Mierzenie tylko adopcji** bez impactu — "wszyscy używają, ale dostarczamy tyle samo"
2. **Lines of Code jako KPI** — AI generuje masę kodu który się wyrzuca
3. **Brak baseline'u przed wdrożeniem** — nie wiesz, czy się poprawiło
4. **Ignorowanie Rework Rate** — krótkoterminowo wygląda super, długoterminowo dług techniczny
5. **Jeden globalny KPI** — różne zespoły (frontend vs. infra vs. ML) mają różne profile użycia AI

## Źródła

### Frameworki

- [DORA State of AI-assisted Software Development 2025](https://dora.dev/research/2025/dora-report/)
- [DORA Report 2025 Key Takeaways — Faros](https://www.faros.ai/blog/key-takeaways-from-the-dora-report-2025)
- [Measuring developer productivity with the DX Core 4](https://getdx.com/research/measuring-developer-productivity-with-the-dx-core-4/)
- [Measuring AI code assistants and agents — DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/)
- [How to implement the AI Measurement Framework — DX](https://getdx.com/blog/how-to-implement-ai-measurement-framework/)
- [SPACE framework — DX](https://getdx.com/blog/space-metrics/)
- [The SPACE of Developer Productivity (oryginalny paper)](https://getdx.com/research/space-of-developer-productivity/)

### Case studies

- [McKinsey: Unleash developer productivity with generative AI](https://www.mckinsey.com/capabilities/tech-and-ai/our-insights/unleashing-developer-productivity-with-generative-ai)
- [McKinsey: Leading AI-driven software organizations](https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/unlocking-the-value-of-ai-in-software-development)
- [GitHub Research: Copilot productivity & happiness](https://github.blog/news-insights/research/research-quantifying-github-copilots-impact-on-developer-productivity-and-happiness/)
- [Zoominfo case study (arXiv)](https://arxiv.org/html/2501.13282v1)
- [Harness: GitHub Copilot case study](https://www.harness.io/blog/the-impact-of-github-copilot-on-developer-productivity-a-case-study)
- [Goldman Sachs autonomous coder pilot — CNBC](https://www.cnbc.com/2025/07/11/goldman-sachs-autonomous-coder-pilot-marks-major-ai-milestone.html)
- [Goldman Sachs scaling AI coding](https://lucidate.substack.com/p/goldman-sachs-scales-ai-coding-to)

### Quality & ROI

- [Three metrics for measuring impact of AI on code quality — DX](https://getdx.com/blog/3-metrics-for-measuring-the-impact-of-ai-on-code-quality/)
- [Defect Escape Rate guide — Opsera](https://opsera.ai/knowledge-base/quality-risk/what-is-defect-escape-rate-der-and-why-it-matters-a-comprehensive-guide/)
- [How to design code quality metrics for AI generated code](https://blog.exceeds.ai/ai-generated-code-quality-metrics/)
- [Measuring AI adoption in your SDLC — Port](https://www.port.io/blog/measuring-ai-adoption-in-your-sdlc)
- [GitHub Copilot usage metrics docs](https://docs.github.com/en/copilot/concepts/copilot-usage-metrics/copilot-metrics)
- [AI Coding ROI for the CFO conversation — Faros](https://www.faros.ai/blog/ai-coding-roi-for-the-cfo-conversation)
- [Top 10 KPIs AI Adoption Dashboard — Worklytics](https://www.worklytics.co/resources/top-10-kpis-ai-adoption-dashboard-2025-dax-formulas)
- [KPIs for gen AI — Google Cloud](https://cloud.google.com/transform/kpis-for-gen-ai-why-measuring-your-new-ai-is-essential-to-its-success)
