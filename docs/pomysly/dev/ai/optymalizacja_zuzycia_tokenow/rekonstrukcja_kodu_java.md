# Rekonstrukcja kodu Java — benchmark tokenów

**TL;DR:** Skrypt usuwa fragmenty klasy Java (np. ciała metod, adnotacje, importy), wysyła okrojony kod do LLM z prośbą o odtworzenie oryginału, a następnie porównuje wynik z oryginałem i raportuje zużycie tokenów przed/po.

## Cel

Zmierzyć, ile kontekstu (tokenów) można zaoszczędzić, wysyłając LLM tylko „szkielet" klasy zamiast pełnego kodu — i jak dokładnie model odtworzy brakujące fragmenty.

## Jak to działa

1. **Wejście:** pełna klasa Java (`.java`)
2. **Usuwanie fragmentów** — skrypt wycina wybrane elementy:
    - ciała metod (zostawia sygnaturę + `// TODO: implement`)
    - komentarze i Javadoc
    - importy (LLM sam je odtworzy)
    - opcjonalnie: adnotacje, stałe, gettery/settery
3. **Licznik tokenów** — zlicza tokeny oryginału i okrojonej wersji (np. przez `tiktoken` lub API Anthropic)
4. **Wywołanie LLM** — prompt: *„Odtwórz pełną oryginalną klasę Java na podstawie poniższego szkieletu"*
5. **Porównanie** — diff oryginału vs. odtworzonego kodu:
    - % zgodności linia po linii
    - % zgodności semantycznej (kompilacja + testy jeśli dostępne)
    - raport różnic

## Przykładowy flow

```
oryginał (2400 tokenów)
    ↓ usunięcie ciał metod
szkielet (800 tokenów)  ← 67% oszczędności
    ↓ LLM rekonstrukcja
odtworzony kod
    ↓ diff vs oryginał
zgodność: 89% (linia po linii), 100% (kompilacja + testy przechodzą)
```

## Metryki do zbierania

| Metryka | Opis |
|---|---|
| Tokeny oryginału | Liczba tokenów pełnej klasy |
| Tokeny szkieletu | Liczba tokenów po usunięciu fragmentów |
| % oszczędności | `(1 - szkielet/oryginał) × 100` |
| % zgodności tekstowej | Ile linii jest identycznych |
| % zgodności semantycznej | Czy kod się kompiluje i przechodzi testy |
| Tokeny odpowiedzi LLM | Ile tokenów zużył model na rekonstrukcję |

## Warianty eksperymentu

- **Poziom usuwania:** tylko ciała metod vs. ciała + importy vs. ciała + importy + adnotacje
- **Typ klasy:** POJO / serwis / kontroler / utility — różne klasy mają różną „przewidywalność"
- **Model:** porównanie Claude vs GPT vs lokalne modele
- **Z kontekstem vs. bez:** czy podanie nazwy projektu / zależności poprawia rekonstrukcję

## Stack technologiczny

- **Java** — skrypt do parsowania i usuwania fragmentów (np. z JavaParser)
- **Spring Boot** — jeśli opakowujemy w REST API
- **Anthropic API** — wywołanie Claude do rekonstrukcji
- **JUnit** — walidacja semantyczna (kompilacja + testy odtworzonego kodu)

## Otwarte pytania

- Czy lepiej usuwać fragmenty losowo czy deterministycznie?
- Jak mierzyć „zgodność semantyczną" bez testów? (np. AST diff)
- Czy warto trenować profil projektu (konwencje, zależności) żeby podać go jako kontekst?
