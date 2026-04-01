# Public Goods Game — LLM Edition

> **TL;DR:** Symulacja Public Goods Game, gdzie uczestnikami są różne modele LLM. Sprawdzamy jak radzą sobie ze współpracą, altruizmem i free-ridingiem. Java Spring Boot + React/TypeScript.

## Koncept

[Public Goods Game](https://en.wikipedia.org/wiki/Public_goods_game) to klasyczny eksperyment z teorii gier:
- Każdy gracz dostaje pulę tokenów
- Decyduje ile wrzucić do wspólnej puli (public good)
- Wspólna pula jest mnożona (np. x1.5) i dzielona równo między wszystkich
- Dylemat: free-riding (wrzucić 0) vs. współpraca (wrzucić wszystko)

## Uczestnicy

Zamiast ludzi — różne modele LLM:
- Claude (Opus, Sonnet, Haiku)
- GPT-4o, GPT-4o-mini
- Gemini Pro
- Llama, Mistral (przez API)

Każdy model dostaje ten sam prompt z opisem gry i podejmuje decyzję ile wrzucić.

## Stack

- **Backend:** Java 17, Spring Boot 3.x
- **Frontend:** React 18, TypeScript, Vite
- **Port:** 8085
- **Katalog:** ~/public-goods-game

## Funkcjonalności

- Konfiguracja gry: liczba rund, mnożnik, pula startowa, wybór modeli
- Wizualizacja rund w czasie rzeczywistym (wykres wkładów per model)
- Ranking modeli po końcowym stanie portfela
- Historia gier z porównaniami
- Analiza strategii: kto cooperuje, kto free-riduje, kto jest tit-for-tat

## Pytania badawcze

1. Który model jest najbardziej kooperatywny?
2. Czy modele uczą się free-ridingu w kolejnych rundach?
3. Jak zmienia się zachowanie gdy modele "widzą" historię ruchów innych?
4. Czy system prompt wpływa na strategię (np. "bądź egoistyczny" vs "bądź altruistyczny")?
