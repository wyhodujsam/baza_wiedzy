# Metryki sukcesu wdrożenia AI w SDLC

> Prezentacja przeglądowa o tym, jak mierzyć realną wartość wdrożenia AI w procesie wytwarzania oprogramowania (DORA, SPACE, DX Core 4 + case studies).

**Data:** 2026-04
**Format:** Marp (16:9), styl Orange Polska
**Źródła pliki:** `~/prezentacje/ai-sdlc-metrics/prezentacja/marp-test/`
**Research:** [research/ai-sdlc-metrics](../research/ai-sdlc-metrics/index.md)

## Plan slajdów

1. **Tytuł** — Metryki sukcesu wdrożenia AI w SDLC
2. **Po co to mierzyć** — Productivity Paradox, 5–15% vs. 50–100%
3. **Divider:** Trzy frameworki
4. **Trzy frameworki pomiarowe** — DORA / SPACE / DX Core 4
5. **DX Core 4** — Speed / Effectiveness / Quality / Impact
6. **Divider:** Cztery kategorie metryk
7. **A. Adopcja** — Active Users, Acceptance, Retention
8. **B. Produktywność** — Cycle Time, PR Throughput, A/B test
9. **C. Jakość** — DER, Rework Rate, pułapka skanerów
10. **D. ROI** — wzory, AI Attribution Factor
11. **Divider:** Realne case studies
12. **Case studies** — Microsoft, ZoomInfo, Goldman, Booking, Harness, McKinsey
13. **Productivity Paradox** — DORA 2025 (akcent)
14. **Stack pomiarowy** — narzędzia
15. **Anti-patterns** — 5 pułapek
16. **Trzy zasady** — podsumowanie (akcent)
17. **Dziękuję** — kontakt

## Build

```bash
cd ~/prezentacje/ai-sdlc-metrics/prezentacja/marp-test
chmod +x build.sh
./build.sh           # HTML (domyślnie)
./build.sh --pdf     # PDF
./build.sh --pptx    # PowerPoint
```

Wynik trafia do `out/prezentacja.{html,pdf,pptx}`.

## Theme

Identyczny jak [Olsztyn 2026 SDD](olsztyn-2026-sdd.md): Orange Polska (`#FF7900`), Helvetica, 16:9, klasy `title` / `divider` / `accent`.
