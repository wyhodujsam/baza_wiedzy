# Generowanie dokumentacji bez LLM

## TL;DR

Narzędzie do automatycznego generowania dokumentacji technicznej (diagramy klas, UML, moduły, integracje) na podstawie analizy kodu — bez użycia LLM. W wersji minimum: template do późniejszego wypełnienia przez LLM.

## Pomysł

Narzędzie, które na podstawie statycznej analizy kodu generuje:

- **Diagramy klas** — relacje, dziedziczenie, zależności
- **UML-e przepływu** — sekwencje wywołań, flow danych
- **Podział na moduły** — grafy zależności między modułami/pakietami
- **Integracje z systemami zewnętrznymi** — wykryte endpointy HTTP, klienty baz danych, kolejki, API calls
- **Template dokumentacji** (MVP) — strukturalny szkielet do wypełnienia przez LLM

## Research — co już istnieje

### Diagramy klas / UML

| Narzędzie | Języki | Co robi |
|-----------|--------|---------|
| **PlantUML + parsery** | Java, Python, C++ | Generuje UML z kodu (np. `java2plantuml`, `py2puml`) |
| **Pyreverse** (pylint) | Python | Diagramy klas i pakietów |
| **javaparser + UML** | Java | AST → diagramy klas |
| **Doxygen** | C/C++/Java/Python | Diagramy klas, call graphs, zależności |
| **Structurizr** | Agnostyczny | C4 model — architektura z kodu (DSL) |

### Analiza zależności / moduły

| Narzędzie | Języki | Co robi |
|-----------|--------|---------|
| **Dependency Cruiser** | JS/TS | Grafy zależności, reguły architektoniczne |
| **JDepend / jQAssistant** | Java | Analiza pakietów, metryki, grafy |
| **Madge** | JS/TS | Wizualizacja drzewa zależności |
| **Pydeps** | Python | Graf zależności modułów |
| **Go callvis** | Go | Wizualizacja call graph |

### Generowanie dokumentacji

| Narzędzie | Języki | Co robi |
|-----------|--------|---------|
| **Doxygen** | Wiele | Pełna dokumentacja z komentarzy + diagramy |
| **Javadoc** | Java | Standardowa dokumentacja API |
| **Sphinx + autodoc** | Python | Dokumentacja z docstringów |
| **TypeDoc** | TypeScript | Dokumentacja API z typów |
| **Dokka** | Kotlin/Java | Dokumentacja API |

### Wykrywanie integracji / endpointów

| Narzędzie | Języki | Co robi |
|-----------|--------|---------|
| **Swagger/OpenAPI generators** | REST APIs | Generuje spec z adnotacji |
| **Spring REST Docs** | Java/Spring | Dokumentacja API z testów |
| **ast-grep** | Wiele | Wyszukiwanie wzorców w AST |

## Wnioski

- Pojedyncze narzędzia istnieją, ale **brak jednego kombajnu** który robi wszystko.
- Luka rynkowa: narzędzie łączące parsery AST + generowanie diagramów + wykrywanie integracji w jeden pipeline.
- MVP: skrypt łączący istniejące toole (np. Pyreverse + Dependency Cruiser + ast-grep) → output w Markdown/PlantUML → template do LLM.

## PoC — wyniki (2026-03-24)

Zbudowano prototyp w Pythonie (regex-based parser, ~600 LOC) i przetestowano na projekcie **wyhodujSam** (254 plików Java).

**Lokalizacja:** `~/wyhodujsam/docs/doc-generator/analyze.py`

### Co narzędzie wykrywa automatycznie

| Element | Baseline (LLM) | Auto-Generated | Pokrycie |
|---------|-----------------|----------------|----------|
| REST endpoints | ~95 | 73 | ~77% |
| Kontrolery | 21 | 22 | 100%+ |
| Konwertery | 21 | 21 | 100% |
| Integracje zewn. | 5 | 5 | 100% |
| State machine enums | 7 | 7 | 100% |
| Typy emaili | 5 | 5 | 100% |
| Typy dokumentów | 4 | 4 | 100% |
| Technologie | 14 | 14 | ~100% |

### Co generuje dobrze (bez LLM)

- Diagram architektury wysokopoziomowy (PlantUML)
- Mapa integracji z systemami zewnętrznymi
- Pełna lista endpointów REST z parametrami
- Diagramy stanów (state machines) z enumów
- Drzewo pakietów z klasyfikacją warstw
- Lista technologii z evidence (imports)
- Pipeline generowania dokumentów PDF
- Flow wysyłania emaili

### Czego brakuje vs baseline (wymaga LLM lub ręcznego uzupełnienia)

- **Opisy biznesowe** — narzędzie widzi "OrderService.placeOrder()" ale nie wie co to znaczy po ludzku
- **Sekwencje biznesowe** — PoC generuje proste łańcuchy controller→service→dao, baseline ma pełne diagramy z logiką warunkową (alt/else)
- **Auth required kolumna** — wymaga analizy SecurityConfiguration, nie samych adnotacji
- **Field usage analysis** — baseline szczegółowo opisuje które pola z PayU response są użyte a które nie
- **Caching strategy** — nie da się wykryć regexem (wymaga analizy logiki)
- **Szczegóły konfiguracji** — np. porty, SMTP host, bucket names (częściowo wyciągane z @Value)

### Wnioski z PoC

1. **~70-80% struktury** dokumentacji da się wygenerować automatycznie
2. **Regex parser wystarczy** na Java/Spring Boot — nie trzeba pełnego AST (JavaParser)
3. **Najlepsza wartość**: diagramy architektoniczne, listy endpointów, state machines, integracje
4. **LLM potrzebny do**: opisów biznesowych, logiki warunkowej w sekwencjach, analizy security
5. **Optymalny flow**: auto-generate → LLM enrichment → human review

## Następne kroki

- [x] Wybrać język na start → Java/Spring Boot
- [x] Zbudować PoC → Python regex-based (600 LOC)
- [x] Zdefiniować format template'u → Markdown + PlantUML (zgodny z baseline)
- [x] Przetestować na realnym projekcie → wyhodujSam (254 klas)
- [x] Zbudować "LLM enrichment" layer → uruchomione jako benchmark template-llm
- [ ] Dodać analizę SecurityConfiguration → kolumna "Auth Required"
- [ ] Dodać parsowanie application.properties → konfiguracja integracji
- [ ] Rozważyć przepisanie na Javę z JavaParser (lepsze AST niż regex)
- [ ] Optymalizacja: szablony inline w prompcie, ograniczenie LLM do uzupełniania

## Benchmark: template-llm vs baseline (2026-03-24)

Pełne wyniki: `~/java-token-benchmark/benchmark-docs/quality-report.md`

| Metryka | baseline (LLM only) | template-llm (static + LLM) |
|---------|---------------------|----------------------------|
| Koszt | **$2.19** | $5.47 (+150%) |
| Czas | ~11m | ~24m (+118%) |
| Turns | 52 | 70 (+35%) |
| Lines | 3,305 | **3,645 (+10%)** |
| Words | 11,650 | **14,677 (+26%)** |
| Diagrams | 27 | **32 (+19%)** |
| Endpoints | 179 | **180** |
| Sub-docs | **15** | 12 |

**Wniosek**: template-llm daje najlepszą jakość ale jest 2.5x droższy. LLM i tak czyta kod źródłowy — szablon nie eliminuje czytania, tylko dodaje "checklist" co dokumentować. Najlepsza relacja jakość/cena: nadal czysty baseline ($2.19).
