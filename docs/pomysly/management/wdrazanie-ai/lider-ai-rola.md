# Lider AI w zespole — karta roli (1-pager)

**TL;DR:** Lider AI to embedded inżynier (10–20% etatu) z mandatem do popularyzacji, weryfikacji celowości i punktowego wymuszania użycia AI w zespole — zawsze pod parasolem CoE i zawsze popartego mierzalnym ROI. Wymuszanie szerokie ("używajcie wszędzie") szkodzi; wymuszanie wąskie na sprawdzonych workflow działa.

## Cel roli

Trzy zdania na tablicę:

1. **Popularyzuje** użycie AI w zespole — pokazuje, mentoruje, dzieli się wzorcami.
2. **Weryfikuje celowość** każdego use case'a — hipoteza → pilot → KEEP / KILL / SCALE.
3. **Egzekwuje standardy** tam, gdzie ROI jest udowodnione — i tylko tam.

## Profil osoby

- Wiarygodność techniczna w zespole (inni już dziś przychodzą po pomoc).
- Realne doświadczenie z narzędziami AI dla deweloperów (Copilot / Claude Code / Cursor).
- Komunikacja w obie strony: do zespołu i do CoE / liderów.
- **Czerwone flagi:** ewangelista bez kodu, sceptyk z misją, "najgłośniejszy".

## Mandat (prawa)

| # | Prawo | Granica |
|---|---|---|
| 1 | Budżet czasu **10–20% etatu** odjęty z capacity zespołu | jawnie w planie sprintu |
| 2 | Wybór toolingu z listy zatwierdzonej przez CoE | nie wprowadza narzędzi spoza listy |
| 3 | **Veto** na wprowadzanie AI tam, gdzie nie ma celowości | wiążące dla zespołu |
| 4 | Mandat lokalny — wymusza standard zespołu na sprawdzonym workflow | wymaga zgody team leada + akceptacji CoE |
| 5 | Dostęp do telemetrii AI w zespole (MAU/DAU, acceptance rate) | bez danych osobowych deweloperów |
| 6 | Bezpośrednia eskalacja do CoE | omija standardową kolejkę |
| 7 | Killswitch — cofnięcie mandatu narzędzia, gdy metryki się sypią | decyzja udokumentowana |

## Obowiązki

**Discovery i celowość**

- Prowadzi rejestr use case'ów: hipoteza → pilot → wynik → decyzja.
- Kwartalnie weryfikuje, czy używane narzędzia nadal mają sens.
- Niesie friction points do CoE.

**Enablement**

- Onboarding nowych członków na zatwierdzony stack — ≤1 tydzień do produktywności.
- "AI office hours" co 1–2 tygodnie — pair programming na żywym kodzie, nie wykład.
- Utrzymuje playbook zespołu: prompty, narzędzia, wzorce.

**Governance lokalna**

- Pilnuje wzmocnionego review dla AI-generated code.
- Egzekwuje politykę danych w promptach (co można, czego nie).
- Reaguje na shadow AI — przyciąga do toola zatwierdzonego, nie karze.

**Pomiar i raportowanie**

- Raport miesięczny do CoE.
- Półroczny review z team leadem: czy rola dowiozła zmianę behawioralną.

## RACI

| Działanie | Lider AI | Team Lead | CoE / Guild | Zespół |
|---|---|---|---|---|
| Wybór narzędzia z listy CoE | **R/A** | C | I | I |
| Dodanie nowego narzędzia (spoza listy) | R | C | **A** | I |
| Wprowadzenie use case'a jako standard zespołu | **R** | **A** | C | I |
| Veto na use case bez celowości | **R/A** | I | I | I |
| Cofnięcie mandatu narzędzia (killswitch) | **R** | C | **A** | I |
| Polityka danych w promptach | C | I | **R/A** | I |
| Onboarding AI dla nowego członka | **R/A** | I | I | I |
| Eskalacja blockera | **R** | C | **A** | I |
| Raport metryk | **R/A** | I | C | I |
| Decyzja o "wymuszaniu" AI globalnie | I | I | **R/A** | I |

R = robi, A = odpowiada, C = konsultowany, I = informowany.

## Metryki sukcesu

**Leading (od dnia 0):**

- MAU ≥ 80% zespołu, DAU ≥ 60%
- Acceptance rate sugestii ≥ 25%
- Czas oszczędzony ≥ 30 min/dev/dzień (self-report + walidacja)

**Lagging (3–12 miesięcy):**

- Lead time -20–50%
- Change failure rate stabilny lub niższy
- Deployment frequency wyższy
- Security findings density bez wzrostu

**Behawioralne:**

- Liczba "killed" use case'ów (zdrowy znak — nie wszystko skalujemy)
- Use case'y z naszego zespołu adoptowane przez inne zespoły

## Co działa (z badań)

- Pilotaż 20–30 osób, mieszane doświadczenie, 6 tygodni, metryki zdefiniowane przed startem.
- 2–3 use case'y "killer" (generowanie testów, AI-asystowany review, dokumentacja PR) zamiast szerokiego frontu.
- Public recognition (badge'e, callout) — niekonkurencyjnie.
- Lekki CoE nad Liderami (1 koordynator na 10–20 Liderów).
- Self-service licencje w toolach zatwierdzonych.

## Czego nie robić (anty-wzorce)

- Lider AI jako trener prowadzący generyczne warsztaty.
- Lider AI jako helpdesk (burnout w 3–6 miesięcy).
- Wybór po entuzjazmie, nie po wpływie społecznym.
- Mandat bez budżetu czasu (pusty tytuł).
- Wymuszanie globalne "używajcie wszędzie" — METR 2025: deweloperzy z dostępem do AI byli o 19% wolniejsi w pewnych zadaniach.
- Vanity metrics (liczba licencji, prompty/dzień) zamiast biznesowych.
- Brak wzmocnionego review — Faros.ai: +54% bugów, 3× incydentów produkcyjnych przy słabej governance.

## Wdrożenie — pierwsze 90 dni

| Tydzień | Krok |
|---|---|
| 0 | Powołanie lekkiego CoE (3–5 osób, część etatu) |
| 1–2 | Wybór 2–3 zespołów pilotażowych + Liderów AI |
| 2 | Karta roli na piśmie (RACI + budżet czasu w planie) |
| 3 | Definicja 2–3 use case'ów do walidacji + metryki przed startem |
| 4–10 | Pilotaż, cotygodniowe office hours, telemetria |
| 11–12 | Review z evidence: które dowiozły, które nie |
| 13+ | Skalowanie tylko na podstawie wyników, nie wiary |

---

**Źródła referencyjne:** OpenAI Academy AI Champion, Lead with AI champion programs, GitHub Copilot adoption guide, Faros.ai scaling guide, Microsoft AI CoE framework, MIT NANDA 2025, METR 2025, Stanford Enterprise AI Playbook.
