# java-token-benchmark

> **TL;DR:** Benchmark oszczędności tokenów przy rekonstrukcji kodu Java przez LLM — parsuje klasy, generuje szkielety, wysyła do Claude, porównuje wyniki.

## Podstawowe info

| | |
|---|---|
| **Katalog** | `~/java-token-benchmark` |
| **Stack** | Java 17, Spring Boot 3.x, JavaParser, Anthropic API, JUnit 5 |
| **Port** | 8084 |
| **Repo** | [github.com/wyhodujsam/java-token-benchmark](https://github.com/wyhodujsam/java-token-benchmark) (private) |

## Opis

Narzędzie do pomiaru, ile kontekstu (tokenów) można zaoszczędzić wysyłając LLM tylko „szkielet" klasy Java zamiast pełnego kodu. Flow:

1. Parsowanie klasy Java przez JavaParser (AST)
2. Usunięcie wybranych fragmentów (ciała metod, importy, Javadoc, adnotacje)
3. Zliczenie tokenów oryginału vs. szkieletu
4. Wysłanie szkieletu do Claude z prośbą o rekonstrukcję
5. Porównanie oryginału z rekonstrukcją (text diff + AST diff + kompilacja)
6. Raport z metrykami w JSON

## Metodologia

SDD (Spec-Driven Development) — pełny flow: specify → plan → tasks → implement. Artefakty w `specs/`.

## Uruchomienie

```bash
cd ~/java-token-benchmark && mvn spring-boot:run
```

## Powiązane

- [Wyniki analizy](java-token-benchmark-wyniki.md) — benchmark 30 klas × 7 poziomów
- [Pomysł w KB](../pomysly/dev/ai/optymalizacja_zuzycia_tokenow/rekonstrukcja_kodu_java.md)
