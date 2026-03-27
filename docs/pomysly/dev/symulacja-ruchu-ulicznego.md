# Symulacja ruchu ulicznego

## TL;DR

Aplikacja webowa symulująca ruch uliczny w celu badania przyczyn powstawania korków. Widok z gory (top-down). Samochody (prostokaty) przyspieszaja i zwalniaja z indywidualnymi parametrami, jada w odstepach. Stack: Java 17 + Spring Boot (backend), React + TypeScript (frontend), WebSocket. Podejscie GSD (get-shit-done).

## Pomysl

Interaktywna symulacja ruchu drogowego, w ktorej:

- **Samochody** poruszaja sie po ustalonych pasach, przyspieszaja i zwalniaja do zadanej predkosci
- **Pasy ruchu** — drogi wielopasmowe, samochody zmieniaja pasy
- **Skrzyzowania** — sygnalizacja swietlna, ronda, pierwszenstwo z prawej strony
- **Przeszkody** — blokuja caly pas, mozna je dodawac/usuwac w trakcie symulacji
- **Zwezenia** — redukcja liczby pasow
- Celem jest obserwacja i analiza **jak powstaja korki** — nawet bez wypadkow czy zdarzen

### Co chcemy zbadac

- **Phantom traffic jams** — korki powstajace "z niczego" (efekt falowy)
- Wplyw gestosci ruchu na przepustowosc
- Jak zmiana cykli sygnalizacji wplywa na plynnosc
- Efekt jednego hamujacego pojazdu na caly pas (propagacja fali)
- Wplyw przeszkod i zwezen na tworzenie sie zatorow

### Model symulacji

- Kazdy pojazd ma: pozycje, predkosc, pas, kierunek, **max predkosc, przyspieszenie, sile hamowania**
- Pojazd przyspieszaja i zwalnia do zadanej predkosci (nie teleportuje sie do niej)
- Pojazd dostosowuje predkosc do pojazdu przed soba (car-following model) — jada w odstepach
- Zmiana pasa z prostymi regulami (jesli wolny pas obok, mozna zmienic)
- Tick-based simulation — backend liczy stan, frontend renderuje
- Samochody przedstawione jako **prostokaty** (widok z gory)

### Widok i interakcja

- **Widok z gory** (top-down, jak na mapie)
- **Mapa**: predefiniowane scenariusze + wczytywanie z konfiguracji (JSON)
- **Docelowo**: edytor map (ekran do rysowania drog)
- **Kontrolki w trakcie symulacji**:
    - Start / Stop / Pauza
    - Predkosc symulacji
    - Dodawanie / usuwanie przeszkod na zywo
    - Zmiana cykli swiatel
    - Spawn rate nowych aut
    - Maksymalna predkosc samochodow
- **Panel statystyk**: srednia predkosc, gestosc, przepustowosc

## Stack technologiczny

| Warstwa | Technologia |
|---------|-------------|
| Backend | Java 17, Spring Boot 3.x |
| Frontend | React 18, TypeScript |
| Komunikacja | WebSocket (real-time update stanu symulacji) |
| Rendering | HTML5 Canvas (widok z gory) |
| Build | Maven (backend), Vite (frontend) |

## Architektura (szkic)

```
┌─────────────────────────────────┐
│          React + TS             │
│  Canvas rendering (top-down)    │
│  Kontrolki + panel statystyk    │
└──────────┬──────────────────────┘
           │ WebSocket
┌──────────┴──────────────────────┐
│       Spring Boot API           │
│  SimulationController           │
│  WebSocketConfig                │
│  MapConfigLoader (JSON)         │
└──────────┬──────────────────────┘
           │
┌──────────┴──────────────────────┐
│     Silnik symulacji            │
│  Road / Lane / Vehicle          │
│  TrafficLight / Intersection    │
│  Roundabout / Obstacle          │
│  SimulationEngine (tick loop)   │
└─────────────────────────────────┘
```

## Kluczowe klasy (backend)

- `Vehicle` — pozycja, predkosc, max predkosc, przyspieszenie, hamowanie, pas, kierunek
- `Lane` — lista pojazdow, kierunek, predkosc max
- `Road` — kolekcja pasow, obsluga zwezen
- `Intersection` — polaczenie drog, sygnalizacja, pierwszenstwo z prawej
- `Roundabout` — rondo z regulami wjazdu/wyjazdu
- `TrafficLight` — cykl zielone/czerwone, konfigurowalne czasy
- `Obstacle` — przeszkoda blokujaca pas
- `SimulationEngine` — glowna petla tick, aktualizacja stanu
- `SimulationState` — snapshot do wyslania przez WebSocket
- `MapConfig` — konfiguracja mapy (drogi, skrzyzowania, pasy) ladowana z JSON

## Nastepne kroki

- [ ] Inicjalizacja projektu przez GSD (new-project)
- [ ] MVP: prosty odcinek drogi wielopasmowej, N samochodow, przyspieszanie/hamowanie
- [ ] Dodac skrzyzowania (swiatla + pierwszenstwo z prawej)
- [ ] Dodac ronda
- [ ] Dodac przeszkody i zwezenia
- [ ] Wczytywanie map z JSON
- [ ] Panel statystyk (srednia predkosc, gestosc, przepustowosc)
- [ ] Edytor map
- [ ] Wizualizacja heatmapy korkow
