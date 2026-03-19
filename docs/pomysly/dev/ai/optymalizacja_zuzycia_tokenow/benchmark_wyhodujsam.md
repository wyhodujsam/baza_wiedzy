# Benchmark optymalizacji tokenów na projekcie wyhodujSam

**TL;DR:** Wykorzystać istniejący projekt wyhodujSam z GitHuba jako poligon do mierzenia efektywności różnych technik optymalizacji zużycia tokenów. Porównywać wyniki na podstawie liczby zużytych tokenów i przechodzących testów.

## Pomysł

Wziąć repozytorium [wyhodujSam](https://github.com/) i użyć go jako środowiska testowego do benchmarku technik optymalizacji tokenów.

## Plan działania

1. **Sklonować repozytorium** wyhodujSam z GitHuba
2. **Dodać testy** — pokryć projekt testami, żeby mieć mierzalny wskaźnik poprawności
3. **Zainicjować SDD spec** — stworzyć specyfikację Spec-Driven Development
4. **Dodać liczniki tokenów** — do każdego zadania implementacyjnego dołączyć pomiar zużycia tokenów
5. **Testować techniki optymalizacji** — wykonywać to samo zadanie różnymi technikami

## Metryki

- **Zużycie tokenów** — ile tokenów (input + output) pochłonęło wykonanie zadania
- **Passing tests** — ile testów przechodzi po wykonaniu zadania

## Techniki do przetestowania

- [ ] Baseline (bez optymalizacji)
- [ ] Skrócone prompty
- [ ] Kontekst ograniczony do minimum
- [ ] Podział na mniejsze zadania
- [ ] Cachowanie kontekstu
- [ ] Różne modele (Opus vs Sonnet vs Haiku)
- [ ] Darmowe modele z OpenRouter — wykorzystać darmowe modele dostępne przez OpenRouter do redukcji kosztów
- [ ] Model routing per task — przed implementacją analizować każde zadanie i przypisywać model wg złożoności (patrz niżej)

## Model routing per task

Pomysł zaimplementowany w `speckit.implement` — przed uruchomieniem zadań Claude analizuje każde z nich i rekomenduje model:

| Złożoność | Model | Kiedy używać |
|-----------|-------|-------------|
| Wysoka | Opus | Wiele zależności, logika finansowa/security, skomplikowane algorytmy |
| Średnia | Sonnet | Standardowe CRUD, typowe testy, umiarkowana liczba zależności |
| Niska | Haiku | Boilerplate, proste testy, konfiguracja, powtarzalne wzorce |

Użytkownik dostaje tabelę `zadanie → rekomendowany model → uzasadnienie` i może zatwierdzić lub zmienić przypisania przed startem. Pozwala to:

- Oszczędzać tokeny na prostych zadaniach (Haiku zamiast Opus)
- Nie tracić jakości na złożonych zadaniach (Opus gdzie trzeba)
- Mierzyć wpływ wyboru modelu na jakość wyniku (passing tests) vs koszt (tokeny)

## Status

Pomysł — do realizacji.
