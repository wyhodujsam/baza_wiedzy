# Traffic Simulator

> Symulacja ruchu ulicznego w widoku z gory (top-down). Samochody z fizyka IDM, wielopasmowe drogi, skrzyzowania z sygnalizacja, ronda, przeszkody.

## Dane

| | |
|---|---|
| **Katalog** | `~/traffic-simulator` |
| **Repo** | [wyhodujsam/traffic-simulator](https://github.com/wyhodujsam/traffic-simulator) |
| **Port backend** | 8086 |
| **Port frontend** | 5173 |
| **Stack backend** | Java 17, Spring Boot 3.3.5, Maven, WebSocket (STOMP/SockJS) |
| **Stack frontend** | React 18, TypeScript, Vite 5, Zustand, HTML5 Canvas, @stomp/stompjs |

## Uruchomienie

```bash
# Backend
cd ~/traffic-simulator/backend && mvn spring-boot:run

# Frontend (osobny terminal)
cd ~/traffic-simulator/frontend && npx vite --host 0.0.0.0
```

Otworz `http://localhost:5173` (lub przez Tailscale).

## Architektura

- **Backend**: silnik symulacji tick-based (20 Hz), fizyka IDM (Intelligent Driver Model), model MOBIL do zmiany pasow
- **Komunikacja**: WebSocket STOMP — backend broadcastuje stan co tick, frontend wysyla komendy (start/pause/obstacle)
- **Frontend**: HTML5 Canvas z interpolacja 60fps, Zustand store, responsywny layout

## Scenariusze map

| Mapa | Opis |
|------|------|
| Straight Road | 3-pasmowa prosta droga 800m |
| Highway Merge | 2-pasmowa autostrada z rampa wjazdowa |
| Four-Way Signal | Skrzyzowanie z sygnalizacja swietlna |
| Phantom Jam Corridor | Dluga 2-pasmowa autostrada — phantom traffic jams |
| Construction Zone | Droga ze zwezeniem (zamkniecie pasa) |
| Roundabout | Rondo z 4 wjazdami |

## Funkcje

- Start/Pause/Stop symulacji, predkosc 0.5x-5x
- Klikniecie na drodze dodaje przeszkode, klikniecie na przeszkodzie usuwa
- Spawn rate i max speed konfigurowalne
- Panel statystyk: srednia predkosc, gestosc, throughput
- Responsywny layout (mobile i desktop)
- Sygnalizacja swietlna z cyklami green/yellow/red + wskaznik box-blocking
