# Benchmark oszczędności tokenów — 30 klas Java

**Data:** 2026-03-22
**Narzędzie:** java-token-benchmark (dry-run, lokalne szacowanie tokenów ~4 znaki/token)
**Próbka:** 30 klas z projektów wyhodujSam i mr-analizer

## Próbka

| Kategoria | Klas | Typ klas | Średnia wielkość |
|-----------|------|----------|-----------------|
| Proste | 10 | DTO, enumy, wyjątki, rekordy | ~17 linii |
| Średnie | 10 | Kontrolery, konwertery, utility, mappery | ~55 linii |
| Złożone | 10 | Serwisy biznesowe, security, adaptery | ~163 linie |

## Poziomy strippingu

| Level | Co usuwa |
|-------|----------|
| `IMPORTS_ONLY` | Wszystkie importy |
| `EXTERNAL_IMPORTS_ONLY` | Importy spoza projektu (java.*, javax.*, biblioteki) |
| `METHOD_BODIES` | Ciała metod → `// TODO: implement` |
| `METHOD_BODIES_IMPORTS` | Ciała metod + importy |
| `METHOD_BODIES_IMPORTS_JAVADOC` | Ciała + importy + Javadoc |
| `FULL` | Wszystko powyżej + adnotacje + gettery/settery |

## Wyniki — średnie oszczędności tokenów

| Level | Proste | Średnie | Złożone |
|-------|--------|---------|---------|
| `IMPORTS_ONLY` | 6.3% | 19.1% | 21.7% |
| `EXTERNAL_IMPORTS_ONLY` | 4.2% | 14.2% | 12.8% |
| `METHOD_BODIES` | 1.2% | 44.5% | 54.3% |
| `METHOD_BODIES_IMPORTS` | 8.2% | 60.9% | 70.8% |
| `METHOD_BODIES_IMPORTS_JAVADOC` | 11.9% | 64.6% | 71.8% |
| `FULL` | 35.0% | 72.6% | 74.6% |

## Top 5 klas — największe oszczędności (METHOD_BODIES)

| Klasa | Kategoria | Linie | Oszczędność |
|-------|-----------|-------|-------------|
| QRCodeGenerator | średnia | 77 | 77.8% |
| GitHubMapper | średnia | 102 | 72.2% |
| ClaudeCliAdapter | złożona | 205 | 68.5% |
| ScoringEngine | złożona | 103 | 67.4% |
| ProductConverter | średnia | 79 | 66.4% |

## Wnioski

### 1. Klasy proste (DTO/enum) — stripping ciał metod prawie nic nie daje

Proste klasy mają mało logiki — ich „ciała" to gettery/settery i jednolinijkowe konstruktory. `METHOD_BODIES` daje zaledwie ~1% oszczędności. Dopiero `FULL` (usunięcie getterów) przynosi 35%, ale kosztem utraty kontekstu pól.

**Wniosek:** Dla klas DTO/POJO lepiej wysyłać je w całości lub stosować `FULL` jeśli LLM zna konwencje projektu.

### 2. Klasy średnie i złożone — ogromne oszczędności z METHOD_BODIES (45-54%)

Im więcej logiki biznesowej w metodach, tym większy zysk z usunięcia ciał. Serwisy i adaptery mają najwięcej kodu w ciałach metod.

**Wniosek:** `METHOD_BODIES` to najważniejszy poziom — sam jeden daje połowę oszczędności.

### 3. Usunięcie importów dodaje ~15-17pp marginalnego zysku

Porównanie `METHOD_BODIES` → `METHOD_BODIES_IMPORTS`: średnio +16pp dla średnich i złożonych klas. Importy są łatwe do odtworzenia przez LLM (wynikają z użytych typów w sygnaturach).

**Wniosek:** Importy to „tani" zysk — niskie ryzyko błędnej rekonstrukcji, a ~16% mniej tokenów.

### 4. Javadoc daje niewielki marginalny zysk (~1-4pp)

Różnica między `METHOD_BODIES_IMPORTS` a `METHOD_BODIES_IMPORTS_JAVADOC` to zaledwie 1-4pp. Większość klas w realnych projektach nie ma obfitego Javadoc.

**Wniosek:** Usuwanie Javadoc opłaca się tylko w projektach z bogatą dokumentacją. W typowych projektach pomijalne.

### 5. EXTERNAL_IMPORTS_ONLY — umiarkowany zysk (4-13%)

Zachowuje importy wewnętrzne projektu (kontekst zależności między klasami) a usuwa standardowe. Mniejszy zysk niż IMPORTS_ONLY, ale bezpieczniejszy — LLM wie jakie klasy projektu są używane.

**Wniosek:** Dobry kompromis gdy chcemy zachować informację o wewnętrznych zależnościach.

### 6. Najlepszy stosunek oszczędność/ryzyko: METHOD_BODIES_IMPORTS

61-71% oszczędności przy zachowaniu: sygnatur metod, pól, adnotacji, struktury klasy. LLM dostaje wystarczający kontekst do sensownej rekonstrukcji.

**Wniosek:** Rekomendowany domyślny poziom dla optymalizacji promptów z kodem Java.

### 7. Punkt malejących zwrotów po METHOD_BODIES_IMPORTS

Dodatkowe poziomy (`+JAVADOC`, `FULL`) przynoszą coraz mniejszy zysk (4-12pp) przy rosnącym ryzyku utraty kontekstu. Adnotacje Spring/JPA to ważna informacja strukturalna.

**Wniosek:** Agresywniejszy stripping (FULL) ma sens tylko gdy LLM ma dostęp do kontekstu projektu (np. inne klasy, konwencje).

## Następne kroki

- [ ] Uruchomić rekonstrukcję (Claude CLI) na wybranych klasach żeby zmierzyć jakość odtworzenia (text match, AST match, kompilacja)
- [ ] Porównać jakość rekonstrukcji między poziomami — czy METHOD_BODIES_IMPORTS daje wystarczająco dobry wynik?
- [ ] Przetestować z kontekstem projektu vs bez — czy podanie nazw zależności poprawia rekonstrukcję?

## Surowe dane

Pełny CSV: `~/java-token-benchmark/reports/full-benchmark.csv`
