# java-token-benchmark — Wyniki analizy

> **TL;DR:** Dry-run benchmark 30 klas Java × 7 poziomów strippingu. FULL daje 35–75% oszczędności tokenów, nowy tryb MINIFIED 0–16%. Dane z 2026-03-22.

## Parametry benchmarku

| | |
|---|---|
| **Data** | 2026-03-22 |
| **Tryb** | dry-run (estymacja tokenów, bez wywołań LLM) |
| **Klasy** | 30 (10 simple, 10 medium, 10 complex) |
| **Poziomy** | 7 (IMPORTS_ONLY, EXTERNAL_IMPORTS_ONLY, METHOD_BODIES, METHOD_BODIES_IMPORTS, METHOD_BODIES_IMPORTS_JAVADOC, FULL, MINIFIED) |
| **Łącznie** | 210 kombinacji, 0 błędów |

## Podsumowanie — średnie oszczędności tokenów (%)

| Poziom | Simple | Medium | Complex |
|--------|--------|--------|---------|
| IMPORTS_ONLY | 6.3 | 19.1 | 21.7 |
| EXTERNAL_IMPORTS_ONLY | 4.2 | 14.2 | 12.8 |
| METHOD_BODIES | 1.2 | 44.5 | 54.3 |
| METHOD_BODIES_IMPORTS | 8.2 | 60.9 | 70.8 |
| METHOD_BODIES_IMPORTS_JAVADOC | 11.9 | 64.6 | 71.8 |
| FULL | 35.0 | 72.6 | 74.6 |
| **MINIFIED** | **-1.5** | **12.3** | **15.7** |

## Wnioski

### Najskuteczniejsze poziomy

- **FULL** (usunięcie ciał metod + importów + javadoc + adnotacji + getterów/setterów) — najwyższe oszczędności: 35–75%
- **METHOD_BODIES_IMPORTS** — dobry balans: 8–71% oszczędności, zachowuje javadoc i adnotacje

### MINIFIED — nowy tryb

Minifikacja a'la JavaScript: zamiana nazw zmiennych, pól i parametrów na jednoliterowe, zachowanie ciał metod i nazw metod. Dodaje javadoc z mapowaniem parametrów.

- **Simple klasy (-1.5%):** Kod za krótki — dodany javadoc z mapowaniem parametrów zjada oszczędności ze skróconych nazw
- **Medium klasy (12.3%):** Umiarkowane oszczędności — nazwy zmiennych stanowią większy % kodu
- **Complex klasy (15.7%):** Najlepiej — długie nazwy (np. `userRepository` → `a`) dają realne oszczędności

**Kluczowa różnica vs inne poziomy:** MINIFIED zachowuje pełne ciała metod (logikę biznesową), więc LLM nie musi rekonstruować kodu — jedynie „deminifikować" nazwy. Trade-off: mniejsze oszczędności tokenów, ale potencjalnie wyższa jakość rekonstrukcji.

### Klasy z najwyższą oszczędnością MINIFIED

| Klasa | Tokens | Savings |
|-------|--------|---------|
| DistanceCalculator | 350 | 28.9% |
| ScoringConfig | 209 | 23.9% |
| AnalyzeMrService | 1117 | 22.9% |
| GitHubMapper | 1120 | 22.6% |
| ProductConverter | 902 | 22.2% |

### Klasy gdzie MINIFIED szkodzi (ujemne savings)

| Klasa | Tokens | Savings |
|-------|--------|---------|
| PlantImgDto | 156 | -12.8% |
| DeliveryStatus | 173 | -5.8% |
| StringWrapperDto | 75 | -5.3% |
| GlobalExceptionHandler | 888 | -3.2% |

Wspólna cecha: klasy z wieloma krótkimi zmiennymi (np. DTO z polami `id`, `name`) — minifikacja skraca je minimalnie, ale dodany javadoc z mapowaniem zwiększa rozmiar.

## Surowe dane

Pełny CSV: `~/java-token-benchmark/reports/full-benchmark.csv`

## Powiązane

- [java-token-benchmark](java-token-benchmark.md) — opis aplikacji
