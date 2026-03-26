# Symulacja ruchu ulicznego

## TL;DR

Aplikacja webowa symulująca ruch uliczny w celu badania przyczyn powstawania korków. Samochody poruszają się po zdefiniowanych pasach z ustaloną prędkością. Stack: Java 17 + Spring Boot (backend), React + TypeScript (frontend). Podejście spec-kit.

## Pomysł

Interaktywna symulacja ruchu drogowego, w której:

- **Samochody** poruszają się po ustalonych pasach z zadaną prędkością
- **Pasy ruchu** mają zdefiniowaną geometrię (kierunek, długość, połączenia)
- **Skrzyżowania** regulują przepływ (sygnalizacja świetlna, pierwszeństwo)
- Celem jest obserwacja i analiza **jak powstają korki** — nawet bez wypadków czy zdarzeń

### Co chcemy zbadać

- **Phantom traffic jams** — korki powstające "z niczego" (efekt falowy)
- Wpływ gęstości ruchu na przepustowość
- Jak zmiana cykli sygnalizacji wpływa na płynność
- Efekt jednego hamującego pojazdu na cały pas (propagacja fali)

### Model symulacji

- Każdy pojazd ma: pozycję, prędkość, pas, kierunek
- Pojazd dostosowuje prędkość do pojazdu przed sobą (car-following model)
- Zmiana pasa z prostymi regułami (jeśli wolny pas obok, można zmienić)
- Tick-based simulation — backend liczy stan, frontend renderuje

## Stack technologiczny

| Warstwa | Technologia |
|---------|-------------|
| Backend | Java 17, Spring Boot 3.x |
| Frontend | React 18, TypeScript |
| Komunikacja | WebSocket (real-time update stanu symulacji) |
| Rendering | HTML5 Canvas lub SVG |
| Build | Maven (backend), Vite (frontend) |

## Podejście: spec-kit

Budowa według metodologii spec-kit:

1. **Specification** — opis wymagań i reguł symulacji
2. **Architecture** — podział na moduły (silnik symulacji, API, UI)
3. **Tasks** — breakdown na implementowalne zadania
4. **Implementation** — krok po kroku z testami

## Architektura (szkic)

```
┌─────────────────────────────────┐
│          React + TS             │
│  Canvas/SVG rendering           │
│  Kontrolki (start/stop/speed)   │
└──────────┬──────────────────────┘
           │ WebSocket
┌──────────┴──────────────────────┐
│       Spring Boot API           │
│  SimulationController           │
│  WebSocketConfig                │
└──────────┬──────────────────────┘
           │
┌──────────┴──────────────────────┐
│     Silnik symulacji            │
│  Road / Lane / Vehicle          │
│  TrafficLight / Intersection    │
│  SimulationEngine (tick loop)   │
└─────────────────────────────────┘
```

## Kluczowe klasy (backend)

- `Vehicle` — pozycja, prędkość, pas, reguły hamowania
- `Lane` — lista pojazdów, kierunek, prędkość max
- `Road` — kolekcja pasów
- `Intersection` — połączenie dróg, sygnalizacja
- `TrafficLight` — cykl zielone/czerwone
- `SimulationEngine` — główna pętla tick, aktualizacja stanu
- `SimulationState` — snapshot do wysłania przez WebSocket

## Następne kroki

- [ ] Napisać spec (spec-kit: specification.md)
- [ ] Zaprojektować architekturę (architecture.md)
- [ ] Rozbić na taski (tasks.md)
- [ ] MVP: jeden prosty odcinek drogi, N samochodów, bez skrzyżowań
- [ ] Dodać skrzyżowania i sygnalizację
- [ ] Dodać wizualizację heatmapy korków
