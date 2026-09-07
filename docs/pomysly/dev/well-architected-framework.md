# Well-Architected Framework — systematyczny review architektury

## TL;DR

Well-Architected Framework (WAF) to rama do **systematycznej oceny systemu** wg sprawdzonych zasad, zorganizowana w 5-6 filarów (reliability, security, cost, performance, operational excellence, [sustainability]). Pochodzi z AWS (2015), Azure i GCP mają własne wersje. Pomysł: użyć WAF — własnego (AWS/Azure) lub vendor-agnostic — jako checklisty review architektury w projektach klientowskich. Nie zastępuje architekta, ale wymusza pytania których nikt nie zadaje, gdy "wszystko działa".

## Czym to NIE jest

- **Nie WELL Building Standard** (to inny WELL — certyfikacja zdrowia budynków, IWBI)
- Nie standard certyfikacyjny — nie ma "WAF compliance certificate"
- Nie konkretny stack — to *zasady*, nie *narzędzia*
- Nie zamiennik architekta — to checklist który wymusza systematyczność

## Wersje i pillars

| Vendor | Pillars | Uwagi |
|--------|---------|-------|
| **AWS** | Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, **Sustainability** | 6 pillars (sustainability dodany 2021). Najbardziej dojrzały |
| **Azure** | Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency | 5 pillars (bez sustainability) |
| **GCP** | Operational Excellence, Security/Privacy/Compliance, Reliability, Cost Optimization, Performance Optimization, System Design | "Cloud Architecture Framework" — 6 obszarów, mniej dojrzały materiał |

Pillary są w ~80% wspólne — można robić **vendor-agnostic Well-Architected Review** bazując na sumie pillarów + odrzucając cloud-specific praktyki.

## Lenses — specjalistyczne nakładki

Lens = wariant filarów dopasowany do konkretnego typu workloadu. AWS ma ich najwięcej:

- **Generative AI Lens** (zaktualizowany 2025) — agentic workflows, prompt engineering, hallucination control, cost per token
- **Machine Learning Lens** (zaktualizowany 2025) — 6 etapów cyklu ML (problem definition → monitoring)
- **Responsible AI Lens** (nowy, re:Invent 2025) — governance, bias mitigation, trust
- Serverless Lens, SaaS Lens, IoT Lens, Migration Lens, Hybrid Networking Lens, Data Analytics Lens, Financial Services Lens, Healthcare Industry Lens

Azure odpowiednik: **AI workload assessment**, Mission-critical assessment, SAP, Oracle.

## Narzędzia

### AWS Well-Architected Tool

W AWS Console: definujesz workload, odpowiadasz na ~50 pytań per pillar, dostajesz listę HRI (High Risk Items) + MRI (Medium Risk Items) z linkami do best practices i AWS Advisor recommendations dla Twojego konta. Wersjonowane — można porównywać reviews w czasie.

### Azure Well-Architected Review

Self-assessment online (~60 pytań), integruje się z **Azure Advisor**. Po zakończeniu: scored report per pillar + export do PowerPointa lub akcji w Azure DevOps / Jira.

### Vendor-agnostic

Można robić review jako **strukturalny warsztat** (1-2 dni z zespołem):

1. Per pillar — lista pytań z dokumentacji vendora
2. Per pytanie — wynik (OK / Risk / Not applicable) + evidence
3. Output — backlog z HRI/MRI

Wersja "lightweight" — checklista w arkuszu kalkulacyjnym lub markdown.

## Kiedy ma sens

- **Przed go-live** — wyłapać HRI których nikt nie zadał w trakcie buildu
- **Po incydencie** — review pillara reliability + operational excellence
- **Periodycznie** (kwartalnie/półrocznie) — przed ewolucją systemu
- **Audyt** — szybka rama do pokazania klientowi/board'owi "co jest ryzykowne"
- **Przed migracją** — Migration Lens
- **Onboardingu nowego AI workloadu** — Responsible AI Lens jako wymóg "trust by design"

## Kiedy nie ma sensu

- **Prototyp / spike** — koszt review > wartość, system za bardzo zmienny
- **Pojedynczy mikroserwis** — WAF jest dla *workloadów*, nie pojedynczych endpointów
- **Brak buy-in od zespołu** — review bez fixów to teatr
- **Środowisko nie-cloud** — WAF zakłada wiele praktyk cloud-native (auto-scaling, managed services); on-prem wymaga adaptacji
- **Compliance-driven org** — jeśli musisz dostarczyć certyfikat (ISO 27001, SOC 2), WAF nie wystarczy — to *uzupełnienie*, nie zamiennik

## Pułapki

1. **Checklist theatre** — odpowiadasz "Yes" na pytania bez evidence. Bez weryfikacji review jest bezwartościowy.
2. **Pillar fatigue** — pełne review przez 6 pillarów to 1-2 dni warsztatu. Dla małych systemów lepiej wybrać 2-3 pillars priorytetowe.
3. **Cloud-specific bias** — AWS WAF promuje rozwiązania AWS (np. "use AWS KMS" zamiast "use KMS"). Trzeba świadomie filtrować.
4. **Recommendations bez priorytetyzacji** — Tool generuje 50+ HRI/MRI. Bez egzekwowania prioryzacji backlog rośnie i nikt go nie czyta.
5. **Brak ownership** — kto zamyka HRI? Bez przypisanego ownera review umiera w sharepoint.
6. **AI Lenses są nowe** — best practices dla LLM/agentów dopiero się kształtują (re:Invent 2025), część rekomendacji jest "aspirational" nie battle-tested.

## Pomysł na eksperyment

Najlepszy kandydat: projekt klientowski w Bluesoft z architekturą cloud (AWS lub Azure), w fazie pre-go-live lub po incydencie.

Etapy:

1. **Spike — vendor-agnostic mini-review** (4-8h): wybrać 2 pillary (np. Reliability + Security), wziąć ~20 pytań z AWS WAF, zrobić warsztat z 2-3 osobami z zespołu. Output: lista HRI w arkuszu.
2. **Triaż** (2h): które HRI faktycznie warto zamknąć, które są "nice to have", które "nie dotyczy".
3. **Pierwszy fix** (1-3 dni): zamknąć 1-3 najwyższe HRI, zmierzyć efekt.
4. **Retrospekcja** (1h): czy proces dał wartość proporcjonalną do kosztu? Czy warto rozszerzyć na pozostałe pillary?

Metryki do oceny ROI:

- Liczba HRI wykrytych przez review które nie były znane wcześniej
- Czas wykrycia HRI vs koszt review (godziny)
- Czy zamknięcie HRI miało mierzalny wpływ (incydent prevented, koszt zaoszczędzony, p95 latency)

## Wariant: AI Lens jako gate dla projektów GenAI

Dla projektów AI/LLM — **Responsible AI Lens** + **Generative AI Lens** jako *wymóg* przed go-live:

- Bias mitigation strategy — dokument
- Hallucination control — testy
- Token cost model — benchmark
- Human oversight — flow
- Data lineage — diagram

Ma sens dla klientów regulowanych (banki, healthcare) gdzie "wdrażamy GenAI bo modne" nie wystarczy — trzeba pokazać governance.

## Następne kroki

- [ ] Wybrać projekt-kandydat (cloud-native, pre-go-live lub post-incident)
- [ ] Spike — mini-review 2 pillarów (4-8h)
- [ ] Triaż HRI + zamknięcie 1-3 najwyższych
- [ ] Retrospekcja: ROI vs koszt
- [ ] Jeśli ROI dodatni → szablon "Well-Architected Review by Bluesoft" jako offering dla klientów
- [ ] Wariant AI: spike Responsible AI Lens na projekcie GenAI

## Powiązane

- [Pact / CDC](pact-cdc.md) — pillar Reliability w WAF zaleca testowanie kompatybilności między usługami; Pact to konkretna technika
- [Graphify ↔ GSD integration](graphify-gsd-integration.md) — graf zależności mógłby być artefaktem dla pillara Operational Excellence (system observability)
- [Generowanie dokumentacji bez LLM](doc-gen-bez-llm.md) — auto-gen diagramów jako evidence dla pillara Operational Excellence

## Źródła

- [AWS Well-Architected Framework — pillars](https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html)
- [AWS Well-Architected — main hub](https://aws.amazon.com/architecture/well-architected/)
- [Azure Well-Architected Framework — pillars](https://learn.microsoft.com/en-us/azure/well-architected/pillars)
- [Azure Well-Architected Review (self-assessment)](https://learn.microsoft.com/en-us/assessments/azure-architecture-review/)
- [Azure AI workload assessment](https://learn.microsoft.com/en-us/azure/well-architected/ai/assessment)
- [AWS Generative AI Lens](https://docs.aws.amazon.com/wellarchitected/latest/generative-ai-lens/generative-ai-lens.html)
- [AWS Machine Learning Lens](https://docs.aws.amazon.com/wellarchitected/latest/machine-learning-lens/machine-learning-lens.html)
- [AWS Responsible AI Lens announcement (2025)](https://aws.amazon.com/blogs/machine-learning/announcing-the-aws-well-architected-responsible-ai-lens/)
- [InfoQ — AWS expands WAF with Responsible AI (Dec 2025)](https://www.infoq.com/news/2025/12/aws-expands-well-architected/)
