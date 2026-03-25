# doc-generator (Static Java Analyzer)

> **TL;DR:** Narzędzie do automatycznego generowania dokumentacji architektonicznej z kodu Java/Spring Boot — bez LLM. Parsuje regexem pliki .java, wyciąga endpointy, integracje, state machines, generuje Markdown + PlantUML.

## Podstawowe info

| | |
|---|---|
| **Katalog** | `~/doc-generator/` |
| **Stack** | Python 3, regex (bez AST parsera) |
| **Port** | — (CLI tool, nie serwer) |
| **Repo** | [github.com/wyhodujsam/doc-generator](https://github.com/wyhodujsam/doc-generator) (private) |
| **LOC** | ~1300 linii |

## Opis

Skrypt `analyze.py` parsuje pliki `.java` i generuje 4 pliki dokumentacji Markdown z diagramami PlantUML. Nie wymaga LLM — działa na podstawie statycznej analizy kodu.

### Co wykrywa

| Element | Metoda | Dokładność (wyhodujsam) |
|---------|--------|------------------------|
| Klasy, dziedziczenie, interfejsy | Regex class/extends/implements | 100% |
| REST endpointy (ścieżki, HTTP method, params) | @GetMapping/@PostMapping parsing | 77% (73/~95) |
| Warstwa architektoniczna | Konwencje nazw pakietów | ~95% |
| Integracje zewnętrzne | Import patterns + keywords | 100% (5/5) |
| State machine enums | Enum + status keyword | 100% (7/7) |
| Typy emaili | Package mail + .twig refs | 100% (5/5) |
| Generatory dokumentów | Package document + .html refs | 100% (4/4) |
| Technologie | Import fingerprinting | 100% (14/14) |

### Co generuje

- `README.md` — index z podsumowaniem
- `overview.md` — statystyki, technologie, diagram architektury, drzewo pakietów, entity/enum listing
- `integrations.md` — lista endpointów z parametrami, mapa integracji zewnętrznych
- `internal-processes.md` — diagramy stanów, łańcuchy procesów, pipeline emaili/dokumentów

## Uruchomienie

```bash
python3 ~/doc-generator/analyze.py <source_dir> <output_dir>

# Przykład:
python3 ~/doc-generator/analyze.py \
  ~/wyhodujsam/garden-serivce/src/main/java \
  /tmp/doc-output
```

## Tryb template-llm (z benchmarkiem)

Dwufazowy pipeline: static analysis → LLM enrichment:

```bash
cd ~/java-token-benchmark/benchmark-docs && bash run-template-llm.sh
```

Phase 1 (free): analyze.py generuje szablon. Phase 2 (LLM): Claude uzupełnia opisy biznesowe, sekwencje, field usage, auth analysis.

## Powiązane

- [java-token-benchmark](java-token-benchmark.md) — projekt benchmarkowy
- [Wyniki benchmarku docs](java-token-benchmark-wyniki-docs.md) — porównanie kosztów i jakości
- [Pomysł w KB](../pomysly/dev/doc-gen-bez-llm.md) — research i wnioski
