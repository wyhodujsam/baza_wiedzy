---
tags: [claude-code, codex, ai-agenci, tailscale, setup]
---

# Stanowisko AI: architektura i przepływy

> **TL;DR:** Jeden laptop (sebastian-AI) pod agentów, dwie subskrypcje (Anthropic → Claude Code z Fable 5.1, ChatGPT Plus → Codex CLI z GPT-6 Astra), telefon jako pilot przez Tailscale i claude-remote. Claude Code jest orkiestratorem i pamięcią, Codex dostaje samowystarczalne zlecenia w plikach (trudne zadania, druga opinia, obrazy). Wersja graficzna: [schemat interaktywny](stanowisko-ai-schemat.html) (stan na 2026-09-07).

## Warstwy

```mermaid
flowchart TB
  subgraph TEL[Telefon · realme GT 2 Pro]
    UI[claude-remote UI · SSE]
    APPS[ChatGPT · claude.ai/code · Gmail · GitHub]
  end
  TS((Tailscale · tailnet))
  subgraph LAP[Laptop sebastian-AI · Ubuntu 24.04 · i7 · 30 GB · bez GPU]
    CR[claude-remote.service · Flask :8080<br/>claude CLI --dangerously-skip-permissions]
    subgraph CC[Claude Code 2.1 · Fable 5.1 · subskrypcja Anthropic]
      MEM[pamięć 57 wpisów · skille · agenci · RTK]
      MCP[MCP: codex · playwright · semgrep · Google Drive]
    end
    subgraph CX[Codex CLI 0.153 · GPT-6 Astra · ChatGPT Plus]
      IMG[$imagegen · gpt-image-2]
      SB[sandbox bwrap + AppArmor · sesje JSONL · codex-trace]
    end
    subgraph INF[Lokalne usługi]
      CRON[cron: 20:58 stoik · 21:17 Garmin · 22:00 KB commit]
      DOCK[Docker: MongoDB :27017 · Structurizr :8087 · mocki sdlc-analyzer]
      OLL[Ollama CPU ~2 tok/s · nie do agentów]
    end
  end
  subgraph CLOUD[Chmura]
    ANT[Anthropic · Fable · artefakty]
    OAI[OpenAI · Astra · gpt-image-2]
    GH[GitHub wyhodujsam]
    EXT[Gmail msmtp · Garmin Connect · Drive]
  end
  UI --> TS --> CR --> CC
  MCP -- "MCP codex / codex exec" --> CX
  CX -- "plik w repo + komunikat" --> CC
  CRON --> CC
  CC --> ANT
  CX --> OAI
  CC --> GH
  CRON --> EXT
```

## Zasada podziału pracy

- **Claude Code (Fable):** kontekst, decyzje, redakcja, korekta, pamięć trwała, git i PR-y. Subagenci (Redaktor, Korektor, reviewerzy) też na Fable.
- **Codex (Astra):** zadania trudne albo wymagające niezależnej weryfikacji, drugi Pisarz w książce 1413, generowanie i edycja obrazów. Nie widzi sesji Claude, więc zlecenie zawsze jako samowystarczalny plik w repo.
- **Telefon:** nie liczy nic sam. Prompt → Tailscale → claude-remote → `claude` CLI; odpowiedź strumieniem SSE; wyniki do czytania jako artefakty HTML na claude.ai/code.
- **Limity Plusa:** jedna pula dla Astry, obrazów i aplikacji ChatGPT (okno 5 h + tydzień). Przed dużym zleceniem: `codex-trace` pokazuje linię LIMITY.

## Przepływ A: obraz do sceny książki

```mermaid
sequenceDiagram
  participant T as Telefon
  participant R as claude-remote
  participant C as Claude Code (Fable)
  participant X as Codex CLI (Astra)
  participant O as OpenAI gpt-image-2
  participant G as GitHub
  T->>R: "wygeneruj obrazy do sceny"
  R->>C: claude CLI + SSE
  C->>C: prompty z kanonicznych opisów lokacji → grafiki/PROMPTY-gpt-image.md
  C->>X: codex exec … "$imagegen, czytaj plik promptów, zapisz PNG" (nohup, w tle)
  X->>O: generacja
  O-->>X: PNG albo odrzucenie (moderacja "violence")
  X-->>C: ścieżka pliku w repo + komunikat końcowy
  C->>C: ogląda PNG, ocenia kanon, KREDYTY.md, strona porównawcza
  C->>G: commit + push na branch PR
  C-->>T: link do artefaktu
  T->>C: poprawka → ta sama droga w trybie edycji obrazu
```

Koszt: ok. 3–4% okna 5 h na obraz. Kadry po walce i pogrzeb są odrzucane, przechodzi tylko statyczny kadr bez kontaktu.

## Przepływ B: scena z Astrą jako Pisarzem

1. **Fable, etap 0:** brief (funkcja, kanon, twarde ograniczenia z gotowej prozy), tło, zlecenie z listą plików do przeczytania w kolejności i notą „mniej sarkazmu".
2. **Fable → Codex:** `codex exec -m gpt-6-astra -c 'model_reasoning_effort="high"' -o wynik.md` w tle.
3. **Astra:** czyta ~20 plików kanonu, pisze draft 5–6 tys. słów (18 min, 2,9 M tokenów in, ~55% okna 5 h).
4. **Subagent Redaktor (Fable):** kanon, rejestr, dramaturgia, powtórzenia; raport zmian i punkty do decyzji autora.
5. **Subagent Korektor (Fable):** tylko język; pewne poprawki naniesione, wątpliwe zostawione.
6. **Fable:** wersja końcowa do `tekst/`, rejestry, strona diff draft ↔ finał, branch + PR.
7. **Telefon:** czytanie porównania, decyzje autora jako kolejne prompty; `/1413-audyt` przed merge.

## Gotchas

- Ubuntu 24.04 blokuje userns dla bwrap: profil `/etc/apparmor.d/bwrap`, po aktualizacji systemu `sudo apparmor_parser -r`.
- `codex exec` wymaga katalogu w repo git (`-C`), domyślny reasoning effort to `none`.
- Skrypty w tle kończyć `exit 0`, inaczej Claude Code raportuje błąd przy pustym `grep -c`.
- Obrazy lądują w `~/.codex/generated_images/`, skill potrafi przenieść je do repo.

Powiązane: [claude-remote](../aplikacje/claude-remote.md), [Structurizr](../aplikacje/structurizr.md).
