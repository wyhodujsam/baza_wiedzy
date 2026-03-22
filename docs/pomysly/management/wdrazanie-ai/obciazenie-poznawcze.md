# Obciążenie poznawcze i zmęczenie decyzyjne przy pracy z AI

**TL;DR:** Długie sesje z asystentem AI prowadzą do spadku uwagi — przestajemy dokładnie czytać komendy wymagające potwierdzenia. W projektach osobistych ryzyko jest niskie, ale w środowisku korporacyjnym to realne zagrożenie. Potrzebny jest mechanizm wymuszonych przerw, analogiczny do tachografu kierowców ciężarówek.

## Problem

Przy dłuższej pracy z AI (np. Claude Code, Copilot) pojawia się efekt przyzwyczajenia:

- **Automatyczne zatwierdzanie** — po N-tym potwierdzeniu komendy przestajemy czytać co dokładnie robimy
- **Złudzenie kontroli** — czujemy, że "AI wie co robi", więc obniżamy czujność
- **Kumulacja zmęczenia** — każda decyzja "approve/deny" zużywa mentalną energię, po godzinie jakość decyzji spada

W kontekście korporacyjnym to oznacza ryzyko:

- Zatwierdzenie destrukcyjnej operacji (drop table, force push, usunięcie zasobów)
- Wyciek wrażliwych danych przez nieprzemyślaną komendę
- Wprowadzenie błędów bezpieczeństwa w kodzie produkcyjnym

## Pomysł: tachometr sesji AI

Wzorem tachografu (obowiązkowego u kierowców ciężarówek w UE), narzędzie które:

1. **Mierzy czas ciągłej pracy** z asystentem AI
2. **Wymusza przerwy** po określonym czasie (np. 45-60 min)
3. **Eskaluje ostrzeżenia** — najpierw delikatne przypomnienie, potem blokada zatwierdzania komend
4. **Loguje sesje** — ile czasu, ile potwierdzeń, jaki stosunek approve/deny (spadek deny = red flag)

### Możliwe metryki "zmęczenia"

- Czas od ostatniej przerwy
- Stosunek approve/deny (jeśli approve > 95% w ostatnich 20 decyzjach — ostrzeżenie)
- Średni czas poświęcony na czytanie komendy przed zatwierdzeniem (< 2s = prawdopodobnie nie czyta)
- Liczba sesji dziennie i łączny czas

### Forma przerwy

- **Spacer** — nawet 10-15 min resetu pomaga; godzinny spacer bywa bardziej produktywny niż 2h przed ekranem
- **Zmiana kontekstu** — code review ręcznie, rozmowa z zespołem, dokumentacja
- **Fizyczna aktywność** — wstanie od biurka, rozciąganie

## Kontekst: projekt osobisty vs korporacja

| Aspekt | Projekt osobisty | Korporacja |
|--------|-----------------|------------|
| Blast radius | Niski — moje repo, mój serwer | Wysoki — produkcja, dane klientów |
| Presja czasu | Brak | Deadline'y skłaniają do skrótów |
| Odpowiedzialność | Tylko moja | Zespół, audyt, compliance |
| Potrzeba tachometru | Niska | Wysoka |

## Następne kroki

- [ ] Zbadać czy istnieją już narzędzia do monitorowania "AI fatigue"
- [ ] Prototyp jako hook w Claude Code (mierzy czas sesji, przypomina o przerwie)
- [ ] Rozważyć integrację z systemami korporacyjnymi (Slack reminder, calendar block)
