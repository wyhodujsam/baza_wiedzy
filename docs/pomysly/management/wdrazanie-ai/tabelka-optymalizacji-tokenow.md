# Tabelka porównawcza optymalizacji zużycia tokenów

**TL;DR:** Potrzebna jest jedna przejrzysta tabelka, która pozwoli managerowi/tech leadowi szybko ocenić które optymalizacje zużycia tokenów warto wdrożyć w zespole — z uwzględnieniem zysków, kosztu wdrożenia, instrukcji i ryzyk.

## Problem

Optymalizacji zużycia tokenów jest wiele (prompt caching, kompresja kontekstu, CLAUDE.md, modele routingu itp.), ale brakuje jednego miejsca gdzie można je porównać pod kątem decyzji wdrożeniowej. Zespół potrzebuje odpowiedzi na pytania:

- Ile zaoszczędzimy?
- Ile czasu zajmie konfiguracja?
- Czy są skutki uboczne?

## Proponowana struktura tabelki

| Optymalizacja | Szacowany zysk | Czas konfiguracji | Instrukcja instalacji | Potencjalne skutki uboczne |
|---------------|---------------|-------------------|----------------------|---------------------------|
| Prompt caching | ~50-90% redukcja kosztów powtarzalnych promptów | 1-2h | [link] | Stale cache przy częstych zmianach promptu |
| CLAUDE.md / system prompt tuning | ~10-30% mniej tokenów w odpowiedziach | 30 min | [link] | Zbyt agresywne skracanie może obniżyć jakość |
| Model routing (haiku/sonnet/opus) | ~40-70% redukcja kosztów | 2-4h | [link] | Słabszy model może nie podołać złożonym zadaniom |
| Kompresja kontekstu | ~20-40% mniej tokenów wejściowych | 1-2h | [link] | Utrata istotnych szczegółów przy zbyt agresywnej kompresji |
| Max tokens / stop sequences | ~10-20% mniej tokenów wyjściowych | 15 min | [link] | Ucięte odpowiedzi jeśli limit za niski |
| ... | ... | ... | ... | ... |

*Powyższe wartości to placeholder — do uzupełnienia na podstawie benchmarków.*

## Wymagania

- [ ] Zebrać rzeczywiste dane o oszczędnościach (nie szacunki vendora, a pomiary z własnych projektów)
- [ ] Dla każdej optymalizacji przygotować krótką instrukcję instalacji (lub link do istniejącej)
- [ ] Opisać skutki uboczne na podstawie doświadczeń — nie teoretycznie
- [ ] Uwzględnić kontekst: co ma sens dla zespołu 3-osobowego vs 20-osobowego
- [ ] Powiązać z istniejącym [benchmarkiem optymalizacji tokenów](../../dev/ai/optymalizacja_zuzycia_tokenow/index.md)

## Grupa docelowa

Tech lead lub engineering manager decydujący o wdrożeniu optymalizacji w zespole. Tabelka powinna być na tyle prosta, żeby można ją było pokazać na spotkaniu i podjąć decyzję w 10 minut.
