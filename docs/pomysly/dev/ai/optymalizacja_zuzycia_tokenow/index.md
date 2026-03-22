# Optymalizacja zużycia tokenów

Benchmark technik optymalizacji zużycia tokenów w zadaniach realizowanych przez AI.

## Artykuły

- [Benchmark na projekcie wyhodujSam](benchmark_wyhodujsam.md) — pomysł na testowanie optymalizacji tokenów na realnym projekcie

- [RTK proxy do przycinania wkładu do LLM](rtk_proxy_do_przycinania_wkladu_do_llm.md) — proxy Rust filtrujące i kompresujące output przed wysłaniem do LLM

- [Rekonstrukcja kodu Java](rekonstrukcja_kodu_java.md) — skrypt usuwający fragmenty klasy Java, LLM odtwarza oryginał, porównanie tokenów i zgodności

- [Minifikacja kodu Java](minifikacja_kodu_java.md) — skracanie nazw zmiennych, usuwanie logowania i komentarzy à la minifikacja frontend, żeby zmniejszyć kontekst LLM

## Wyniki

- [Wyniki analiz](wyniki_analiz/index.md) — raporty z eksperymentów
    - [Benchmark 30 klas Java](wyniki_analiz/benchmark_30_klas.md) — dry-run na 6 poziomach strippingu, wnioski