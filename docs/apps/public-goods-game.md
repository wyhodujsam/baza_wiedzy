# Public Goods Game — LLM Edition

> **TL;DR:** Symulacja gry w dobra publiczne z modelami Claude (Opus, Sonnet, Haiku) jako graczami. Badanie kooperacji, free-ridingu i wpływu promptów na strategię.

## Stack

- **Backend:** Java 17, Spring Boot 3.2.5, Spring Data JPA, H2
- **Frontend:** React 18, TypeScript, Vite 5, Recharts
- **Port:** 8085 (backend), 3005 (frontend dev)
- **Katalog:** `~/public-goods-game`

## Uruchomienie

```bash
export ANTHROPIC_API_KEY=sk-ant-...
cd ~/public-goods-game/backend && mvn spring-boot:run
# osobny terminal:
cd ~/public-goods-game/frontend && npx vite
```

## Funkcjonalności

- Konfiguracja gry: wybór modeli, liczba rund, endowment, mnożnik
- Live wykresy (contributions + balance) aktualizowane po każdej rundzie (SSE)
- Customowe system prompty per model
- Historia gier z pełnym drill-down
- Persystencja w H2 (plik `./data/games.mv.db`)

## Jak działa

Każda runda: model dostaje prompt z regułami gry i historią → odpowiada ile wrzuca do wspólnej puli → pula × mnożnik / liczba graczy → podział. Gra bada dylemat: free-riding (wrzuć 0) vs. kooperacja (wrzuć max).
