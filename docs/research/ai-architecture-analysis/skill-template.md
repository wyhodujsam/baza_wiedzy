# Szablon SKILL.md dla analizy architektonicznej w T3

> Skopiuj ten plik do `.claude/skills/architecture-analysis/SKILL.md` (Claude Code), `.cursor/rules/architecture.md` (Cursor) lub `CLAUDE.md` w głównym repo. Uzupełnij sekcje oznaczone `<TODO>`.

---

```markdown
---
name: T3 — Architecture & BL Analysis
description: Skill do analizy architektonicznej i mapowania BL z Jira na komponenty/procesy. Używaj zawsze gdy zadanie dotyczy projektowania zmiany lub walidacji wymagania biznesowego.
---

# T3 Architecture Analysis Skill

## Kontekst zespołu

Zespół T3 wytwarza i utrzymuje dwa obszary:

- **A. Hybris** — monolit współdzielony z innymi zespołami
- **B. MS LC** — własne mikroserwisy (pełna kontrola)

Jeden flow biznesowy zwykle przekrojowo używa obu obszarów.

## Mapa systemów

### Obszar A — Hybris

| Moduł | Repo | Owner | Co robi |
|---|---|---|---|
| <TODO: hybris-core> | <TODO: gitlab url> | T3 + inne zespoły | <TODO: opis> |
| <TODO: hybris-billing> | ... | ... | ... |

### Obszar B — Mikroserwisy MS LC

| Serwis | Repo | Port | Co robi |
|---|---|---|---|
| <TODO: ms-lc-core> | <TODO> | <TODO> | <TODO> |
| <TODO: ms-lc-orders> | ... | ... | ... |
| <TODO: ms-lc-payments> | ... | ... | ... |
| <TODO: ms-lc-notifications> | ... | ... | ... |
| <TODO: ms-lc-eflow> | ... | ... | ... |
| <TODO: ms-lc-...> | ... | ... | ... |

### Integracje cross-area

- `<TODO: jak Hybris woła MS LC>` (REST? Event? Kafka topic?)
- `<TODO: jak MS LC woła Hybris>`
- `<TODO: shared database/state>`

## Słownik domeny — biznes ↔ technika

| Termin biznesowy | Komponenty techniczne |
|---|---|
| Symfonia 6 | Hybris core + <TODO: jakie moduły> |
| eFlow | <TODO: ms-lc-eflow + integracje> |
| <TODO: inne nazwy projektów/feature'ów> | <TODO> |

## Kluczowe ADR-y (decyzje historyczne)

1. **ADR-001: Gherkin tylko po stronie MS LC**
   Konsekwencja: scenariusze testowe Hybris zostają w Jirze (naturalny język).

2. **ADR-002: Warsztat 4-stronny po zamrożeniu BL**
   Uczestnicy: AR + PO + TechLead + Tester. Output: scenariusze + szkic koncepcji.

3. **ADR-003: Każde zadanie techniczne ma link do scenariusza**
   Reguła DoR: bez scenariusza nie wchodzi do sprintu.

4. **<TODO: ADR-004 — np. "Nowe funkcje wchodzą do MS LC, nie do Hybris">**
5. **<TODO: ADR-005>**

## Wzorzec analizy BL

Gdy użytkownik wkleja tekst BL z Jira — wykonaj poniższe kroki **po kolei**:

### 1. Walidacja jakości wymagania

Sprawdź obecność (✅/❌):
- [ ] Cel biznesowy (po co)
- [ ] Acceptance Criteria (mierzalne)
- [ ] Zakres (co IN, co OUT)
- [ ] NFR-y (wydajność, bezpieczeństwo, dostępność)
- [ ] Zależności od innych BL (linki Jira)
- [ ] Stakeholderzy / roles

Jeśli brakuje — wypisz luki i zaproponuj pytania do AR/PO.

### 2. Mapowanie na systemy

Dla każdego zdania BL znajdź **dotykane komponenty z mapy systemów powyżej**.

⚠ **Reguła:** wolno używać tylko nazw z sekcji "Mapa systemów". Jeśli wymaganie wymaga czegoś, czego tam nie ma — zaznacz to jako "wymaga decyzji architektonicznej (nowy ADR)".

Format:
```
Komponent X (obszar A/B) — co konkretnie się zmienia
```

### 3. Identyfikacja konfliktów

Sprawdź czy BL nie:
- modyfikuje tego samego komponentu co inne aktywne BL w sprzeczny sposób
- łamie któryś z istniejących ADR
- nakłada się z innym BL z tej samej iteracji

Format:
```
⚠ KONFLIKT: <opis> | dotyczy: <ADR-XXX / STORY-YYY>
```

### 4. Propozycja scenariuszy BDD

Dla obszaru B (MS LC) — wygeneruj szkielet w Gherkinie.
Dla obszaru A (Hybris) — wygeneruj scenariusze w naturalnym języku (struktura: Sytuacja / Akcja / Oczekiwanie).

### 5. Identyfikacja "białych plam"

- Co z BL **nie zostanie pokryte** żadnym scenariuszem? → ryzyko PBI na produkcji
- Czy planowane scenariusze pokrywają coś **spoza BL**? → ryzyko długu technicznego

## Format outputu

Zawsze odpowiadaj w tym układzie:

```markdown
# Analiza BL: <ID Jira> — <tytuł>

## 1. Jakość wymagania
✅ Spełnione: ...
❌ Luki: ...
❓ Pytania do AR/PO: ...

## 2. Dotykane komponenty
- **Hybris**: <lista>
- **MS LC**: <lista>
- **Cross-area integracje**: <lista>

## 3. Konflikty / ryzyka ADR
<lista lub "brak">

## 4. Propozycja scenariuszy
<scenariusze>

## 5. Białe plamy
- **Ryzyko PBI**: <co nie zostanie przetestowane>
- **Ryzyko długu**: <co testujemy spoza BL>

## 6. Rekomendacja
- Decyzja: <gotowe do warsztatu / wymaga doprecyzowania / wymaga nowego ADR>
- Następny krok: <konkretna akcja>
```

## Anti-patterns — NIGDY tego nie rób

1. **Nie wymyślaj nazw komponentów** których nie ma w "Mapa systemów" — jeśli BL wymaga nowego, oznacz "wymaga ADR".
2. **Nie podejmuj decyzji architektonicznej** (np. "Hybris vs nowy mikroserwis") — sygnalizuj że wymaga warsztatu i ADR.
3. **Nie przepisuj BL na własną rękę** — sygnalizuj luki i pytaj.
4. **Nie generuj scenariuszy które wykraczają poza BL** — jeśli widzisz potencjalną ścieżkę spoza zakresu, oznacz "spoza BL, do osobnego ticketu".
5. **Nie używaj Gherkina dla obszaru A (Hybris)** — to łamie ADR-001.
6. **Nie wnioskuj na podstawie nazw plików/klas** o intencji biznesowej — pytaj AR/PO.

## Źródła do dalszego pogłębienia

- `<TODO: link do Confluence z arc42>`
- `<TODO: link do repozytorium ADR-ów>`
- `<TODO: link do BPMN procesów biznesowych>`
```

---

## Jak tego używać

### W Claude Code

```bash
mkdir -p .claude/skills/architecture-analysis
# wklej zawartość powyżej do .claude/skills/architecture-analysis/SKILL.md
```

Claude wykryje skill automatycznie. Wywołujesz: po prostu wklejasz tekst BL z Jira i mówisz "analiza BL". Albo bezpośrednio `/architecture-analysis` jeśli ustawisz alias.

### W Cursor / Cline / Continue

- **Cursor**: `.cursor/rules/architecture.md` (auto-loaded jako project rule)
- **Cline**: dorzuć do "Custom Instructions" w settings
- **Continue.dev**: `~/.continue/config.json` → custom commands

### W ChatGPT / Claude Web

Wklej całość jako pierwszy message w nowym czacie ("To jest mój skill, używaj go zawsze gdy proszę o analizę BL"), albo użyj jako "Custom GPT" / "Project instructions".

## Kolejność rozwoju

```
Skill (1h)  →  Skill + MCP Atlassian (1 dzień)  →  Skill + ADR repo (2 tygodnie)  →  Skill + GraphRAG (3+ miesiące)
   ↑              ↑                                    ↑                              ↑
 80% wartości   90% wartości                         95% wartości                   100% (rzadko potrzebne)
```

**Każdy następny krok dodaje 5-10% wartości za 10× więcej pracy.** Większość zespołów zatrzymuje się na poziomie skill + MCP — i wystarcza.

## Pułapki przy samym skillu

1. **Stary skill = błędne odpowiedzi** — zaplanuj review co kwartał (ADR-y się zmieniają, nowe mikroserwisy)
2. **Skill > 800 linii = LLM gubi kontekst** — jeśli masz dużo, podziel na `architecture-analysis-hybris/SKILL.md` i `architecture-analysis-msLC/SKILL.md`
3. **Brak konkretów = halucynacje** — `<TODO: ...>` w szablonie MUSZĄ być uzupełnione, inaczej Claude zacznie zmyślać
4. **Skill ≠ dokumentacja** — skill to **instrukcja dla agenta**, dokumentacja to dla ludzi. Nie mieszaj.
