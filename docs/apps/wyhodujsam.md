# wyhodujSam

> **TL;DR:** Backend platformy do zarządzania ogrodami, roślinami, zamówieniami i dostawami. Spring Boot 2.2.6, Java 8, Maven, port 9999.

## Podstawowe info

| Parametr | Wartość |
|----------|---------|
| Lokalizacja | `~/wyhodujsam/garden-serivce/` |
| Port | 9999 |
| Branch | `prod_11_04_2021` |
| Repo | `github.com/wyhodujsam/wyhodujsam.git` |
| Build | `./mvnw spring-boot:run` |
| Testy | `mvn test` (11 testów, 6 klas) |

## Stack

- Java 8, Spring Boot 2.2.6, Maven (WAR)
- H2 (dev), MySQL/PostgreSQL (prod)
- Spring Security (custom + Facebook OAuth)
- AWS SES (mail), AWS S3 (pliki), PayU (płatności)
- Google Maps API (geokodowanie)
- Flying Saucer + Thymeleaf (PDF), ZXing (QR kody)

## Moduły

Ogrody, rośliny, zamówienia, płatności (PayU), dostawy, rezerwacje, produkty, vouchery, dyspozycje, rekomendacje, CMS, lokalizacje, dokumenty PDF, maile, użytkownicy.

## Architektura

```
Controller → Service → DAO (impl) → JPA/Hibernate
     ↕            ↕
    DTO ← Converter
```

## SDD (Spec-Driven Development)

Projekt używa GitHub Spec Kit. Specyfikacje w `~/wyhodujsam/specs/`.

## Uwagi

- Literówka w nazwie katalogu: `garden-serivce` (zamiast `garden-service`)
- Credentials w `application.properties` — do wyciągnięcia do env vars
