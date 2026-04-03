# Wpływ nazw zmiennych na koszt i skuteczność LLM

> **TL;DR:** Eksperyment sprawdzający, jak niepoprawne/mylące nazwy zmiennych wpływają na koszt tokenowy i skuteczność wykonania zmian w kodzie przez LLM.

## Hipoteza

Złe nazwy zmiennych (skróty, mylące nazwy, jednoliterowe identyfikatory) zmuszają LLM do:

- zużycia większej liczby tokenów na zrozumienie kodu (dłuższe rozumowanie)
- częstszych błędów przy implementacji zmian
- dodatkowych iteracji poprawek (retry), co mnoży koszty

## Plan eksperymentu

1. **Przygotować dwie wersje tego samego kodu** — identyczna logika, różne nazewnictwo:
    - wersja A: czytelne, opisowe nazwy (`customerOrder`, `calculateTotalPrice`)
    - wersja B: złe nazwy (`co`, `ctp`, `data1`, `processStuff`, mylące nazwy jak `getUser` zwracające order)
2. **Zlecić LLM tę samą zmianę** na obu wersjach (np. dodanie walidacji, refactor, nowa funkcjonalność)
3. **Zmierzyć**:
    - tokeny wejściowe i wyjściowe (koszt)
    - liczbę prób do poprawnego rozwiązania (skuteczność)
    - czas do poprawnego rozwiązania
    - jakość wygenerowanego kodu (czy LLM kontynuuje złe konwencje czy naprawia?)

## Warianty do zbadania

- Różne poziomy "zepsutych" nazw (lekko mylące vs kompletnie losowe)
- Różne modele LLM (Claude, GPT, Gemini) — czy któryś jest bardziej odporny?
- Różne języki programowania (Java, Python, TypeScript)
- Różne rodzaje zadań (bug fix, nowa funkcja, refactor)

## Oczekiwane wyniki

- Wyraźny wzrost kosztów przy złych nazwach (więcej tokenów reasoning)
- Spadek skuteczności first-try (więcej błędów)
- Praktyczny argument za inwestowaniem w czytelne nazewnictwo — ROI mierzalny w $ tokenów

## Powiązane

- [Optymalizacja zużycia tokenów](optymalizacja_zuzycia_tokenow/index.md) — pokrewny temat badania kosztów tokenowych
