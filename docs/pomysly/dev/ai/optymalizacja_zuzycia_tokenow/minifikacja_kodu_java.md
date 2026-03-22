# Minifikacja kodu Java dla kontekstu LLM

**TL;DR:** Analogicznie do minifikacji JS/CSS na frontendzie — skrócenie nazw zmiennych, usunięcie logowania, komentarzy i białych znaków w kodzie Java przed wysłaniem do LLM. Cel: zmniejszyć liczbę tokenów w kontekście bez utraty semantyki kodu.

## Pomysł

Frontend od lat minifikuje kod żeby zmniejszyć rozmiar przesyłanych plików. Ten sam koncept można zastosować do kodu wysyłanego jako kontekst do LLM — nie zależy nam na czytelności dla człowieka, tylko na zachowaniu semantyki dla modelu.

## Możliwe transformacje

| Transformacja | Przykład | Szacowany zysk tokenów |
|---------------|---------|----------------------|
| Skrócenie nazw zmiennych | `customerOrderRepository` → `a` | Wysoki — Java słynie z długich nazw |
| Usunięcie logowania | `logger.info("Processing order {}", id)` → *(usunięte)* | Średni — logi to często 10-20% kodu |
| Usunięcie komentarzy i Javadoc | `/** Returns the... */` → *(usunięte)* | Średni |
| Usunięcie białych znaków i wcięć | Formatowanie → jedna linia | Niski-średni |
| Skrócenie nazw metod | `calculateTotalPrice()` → `f1()` | Średni |
| Usunięcie getterów/setterów | Boilerplate → *(usunięte lub skrócone)* | Wysoki w klasycznych POJO |
| Usunięcie importów | `import java.util.List` → *(usunięte)* | Niski |
| Collapse adnotacji | `@Override @Transactional(readOnly = true)` → `@T(ro)` | Niski-średni |

## Różnice vs rekonstrukcja kodu

[Rekonstrukcja kodu Java](rekonstrukcja_kodu_java.md) usuwa ciała metod i liczy na to, że LLM je odtworzy. Minifikacja zachowuje pełną logikę — tylko ją kompresuje. To komplementarne podejścia:

- **Rekonstrukcja** — gdy LLM ma *napisać* brakujący kod
- **Minifikacja** — gdy LLM ma *zrozumieć* istniejący kod (code review, analiza, debug)

## Ryzyka i skutki uboczne

- **Utrata czytelności w odpowiedzi** — LLM może odpowiadać używając zminifikowanych nazw (`a` zamiast `customerOrderRepository`), trzeba mapować z powrotem
- **Strata kontekstu semantycznego** — nazwa `calculateTotalPrice` niesie informację, `f1()` nie — model traci podpowiedzi z nazewnictwa
- **Złożoność toolingu** — potrzebny parser AST (np. JavaParser), nie wystarczy regex
- **Mapowanie zwrotne** — odpowiedzi LLM trzeba "deminifikować" żeby były użyteczne dla programisty

## Implementacja

- Użyć [JavaParser](https://javaparser.org/) do parsowania AST i transformacji
- Generować mapę nazw (oryginał → skrót) do deminifikacji odpowiedzi
- Konfigurowalny poziom agresywności (np. tylko logi i komentarze vs pełna minifikacja)
- Benchmark: ten sam prompt z kodem oryginalnym vs zminifikowanym — porównać jakość odpowiedzi i zużycie tokenów

## Pytania otwarte

- Jaki poziom minifikacji jest optymalny? (za dużo → model traci kontekst, za mało → niewielki zysk)
- Czy LLM lepiej radzi sobie z kodem sformatowanym czy zminifikowanym? Może formatowanie pomaga modelowi
- Czy warto minifikować selektywnie — np. tylko kod pomocniczy, a core logic zostawić czytelną?
