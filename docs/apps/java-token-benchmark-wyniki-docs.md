# java-token-benchmark — Wyniki benchmarku dokumentacji

> **TL;DR:** Testowano 7 trybów generowania dokumentacji architektonicznej. Baseline ($2.19) ma najlepszą relację jakość/cena. Template-llm ($5.47) daje najwyższą jakość (+26% słów) ale 2.5× droższy. jsk nie oszczędza tokenów.

## Eksperyment

7 runów generowania dokumentacji projektu wyhodujsam (254 plików Java):

| Run | Opis | Cost | vs baseline | Words | Diagrams | Sub-APIs |
|-----|------|------|-------------|-------|----------|---------|
| jsk-EXTERNAL_IMPORTS_ONLY | Usunięte zewn. importy | **$1.89** | **-14%** | 7,236 | 31 | 0 |
| **baseline** | Pełny kod, Read tool | **$2.19** | — | 11,650 | 27 | 15 |
| jsk-METHOD_BODIES | Ciała metod → TODO | $2.30 | +5% | 12,274 | 31 | 15 |
| jsk-METHOD_BODIES_IMPORTS | + usunięte importy | $2.89 | +32% | 9,022 | 28 | 5 |
| jsk-FULL | Maksymalny stripping | $4.38 | +100% | 8,860 | 29 | 0 |
| jsk-MINIFIED | Jednoliterowe zmienne | $5.44 | +148% | 7,027 | 26 | 0 |
| **template-llm** | Static analyzer + LLM | **$5.47** | **+150%** | **14,677** | **32** | 12 |

## Template-llm — nowy tryb

Dwufazowy pipeline:

1. **Phase 1 (free):** Skrypt Python parsuje regexem 254 plików Java → generuje szablon dokumentacji (endpointy, klasy, integracje, state machines, PlantUML)
2. **Phase 2 (LLM):** Claude czyta szablon + kod źródłowy → uzupełnia opisy biznesowe, sekwencje, field usage, auth analysis

| Metryka | baseline | template-llm |
|---------|----------|-------------|
| Koszt | $2.19 | $5.47 (+150%) |
| Czas | ~11m | ~24m |
| Words | 11,650 | **14,677 (+26%)** |
| Diagrams | 27 | **32 (+19%)** |
| Endpoints | 179 | **180** |
| Turns | 52 | 70 |
| Cache Read | 622K | 3,209K (5×) |

**Dlaczego droższy?** LLM i tak czyta pliki źródłowe żeby wzbogacić szablon — szablon dodaje pracę zamiast ją zastępować. Cache Read 5× wyższy. Ale jakość najlepsza: szablon działa jako checklist, gwarantując kompletność.

## Wnioski

- **Najlepsza relacja jakość/cena:** baseline ($2.19) — dobra jakość, najniższy koszt
- **Maksymalizacja jakości:** template-llm ($5.47) — najlepsza jakość, 2.5× droższy
- **jsk nie opłaca się** przy głębokiej analizie — agent kompensuje brak kontekstu czytając więcej
- **MINIFIED najgorszy** — jednoliterowe zmienne zaciemniają semantykę, 79 tur vs 52 baseline
- **Szablon nie oszczędza tokenów** — LLM i tak czyta źródła; wartość szablonu = checklist completeness

Paper: `~/java-token-benchmark/benchmark-docs/paper-template-llm.pdf`

## Powiązane

- [java-token-benchmark](java-token-benchmark.md)
- [doc-generator](doc-generator.md) — statyczny analizator Java
- [Wyniki analizy szkieletów](java-token-benchmark-wyniki.md)
