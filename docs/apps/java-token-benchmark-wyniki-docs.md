# java-token-benchmark — Wyniki benchmarku dokumentacji

> **TL;DR:** jsk (Java Skeleton) nie oszczędza tokenów przy generowaniu dokumentacji — baseline bez jsk jest 2× tańszy niż FULL. Agent kompensuje brak informacji czytając więcej plików.

## Eksperyment

4 runy generowania dokumentacji architektonicznej projektu wyhodujsam (276 plików Java):

| Run | Opis | Cost | vs baseline | Lines | Sub-APIs |
|-----|------|------|-------------|-------|---------|
| jsk-EXTERNAL_IMPORTS_ONLY | Usunięte zewn. importy | **$1.89** | **-14%** | 1,945 | 0 |
| **baseline** | Pełny kod, Read tool | $2.19 | — | 3,305 | 15 |
| jsk-METHOD_BODIES | Ciała metod → TODO | $2.30 | +5% | 3,161 | 15 |
| jsk-METHOD_BODIES_IMPORTS | + usunięte importy | $2.89 | +32% | 2,333 | 5 |
| jsk-FULL | Maksymalny stripping | $4.38 | +100% | 2,329 | 0 |
| jsk-MINIFIED | Jednoliterowe zmienne | **$5.44** | **+148%** | 1,833 | 0 |

## Wniosek

EXTERNAL_IMPORTS_ONLY jedyny tańszy (-14%) ale generuje mniej treści. MINIFIED najgorszy (+148%) — jednoliterowe zmienne zaciemniają semantykę i agent robi 79 tur zamiast 52. Im więcej informacji stripujemy, tym drożej — agent kompensuje brak kontekstu robiąc więcej odczytów (Cache Read: 622K → 1.51M). jsk nie opłaca się przy głębokiej analizie wymagającej wielokrotnego wracania do źródeł.

## Powiązane

- [java-token-benchmark](java-token-benchmark.md)
- [Wyniki analizy szkieletów](java-token-benchmark-wyniki.md)
