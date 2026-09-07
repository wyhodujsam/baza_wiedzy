# Nebius — hostowanie open-source modeli AI

> Research o europejskim cloudzie AI (NASDAQ: NBIS) jako alternatywie dla OpenAI/Together/Fireworks dla hostowania modeli open-source. EU sovereignty, OpenAI-compatible API, tanie GPU.

**Data:** 2026-04-30
**Powiązane:** [AI SDLC Metrics](../ai-sdlc-metrics/index.md)

## TL;DR

- **Trzy produkty:** AI Cloud (bare GPU), AI Studio (managed inference, OpenAI-compat), Token Factory (production endpoints)
- **Ceny:** Llama 3.1 405B za **$1/$3 per M tokens**, H100 za **$2.95/h** on-demand (najtańsze na rynku)
- **EU sovereignty:** DC w Finlandii, Francji, UK; GDPR/NIS2/HIPAA/ISO 27001
- **Pełna kompatybilność z OpenAI SDK** — migracja w 3 minuty (zmiana base_url + key)
- **Brak Claude'a/GPT-4** (konkurencja); świetne dla Llama, DeepSeek, Qwen, Mistral, GPT-OSS

## Co to jest

NASDAQ-listed cloud z HQ w Amsterdamie, spinoff Yandex N.V. (formalnie odcięty). Pełen stack: GPU compute → managed inference → fine-tuning. Pozycjonują się jako **"sovereign AI cloud Europy"**.

## Trzy produkty

| Produkt | Co to | Dla kogo |
|---|---|---|
| **Nebius AI Cloud** | Bare GPU (H100/H200/Blackwell Ultra) + Kubernetes/Slurm | Self-host, training, custom inference |
| **Nebius AI Studio** | Managed serverless inference, 60+ open-source modeli, OpenAI-compatible API | Dev / prototyp / production |
| **Nebius Token Factory** (Nov 2025) | Dedicated endpoints z SLA 99.9%, autoscaling, custom-model hosting | Production przy dużej skali |

## Modele dostępne

- **Llama** 3.1 (8B, 70B, 405B), 3.3
- **DeepSeek** R1, V3
- **Qwen** 2.5, QwQ
- **Mistral** / Mixtral
- **NVIDIA Nemotron**
- **GPT-OSS** (otwarte modele OpenAI)
- Modele text-to-image (FLUX itp.)

60+ modeli total.

## Pricing

### Inference (per token)

| Model | Input ($/1M) | Output ($/1M) |
|---|---|---|
| Llama 3.1 **405B** | **$1.00** | **$3.00** |
| Llama 3.1 70B | ~$0.13 | ~$0.40 |
| Llama 3.1 8B | ~$0.02 | ~$0.06 |
| DeepSeek R1 | sprawdzić bieżący cennik | — |

Dwa flavours:
- **Fast** — niższa latencja, droższe (interactive)
- **Base** — tańsze, batch / background

### GPU on-demand (self-host)

| GPU | $/hr on-demand | Z 3-mies. commitment |
|---|---|---|
| H100 | **$2.95** | -35% (~$1.92) |
| H200 | ~$3.50 | ~$2.30 |
| Blackwell Ultra (B200) | brak publicznego cennika | — |

H100 to **jedna z najniższych stawek na rynku** (Lambda ~$2.49–2.99, RunPod ~$2.69, AWS p5 ~$8+).

## API — OpenAI-compatible

Endpointy:
- AI Studio: `https://api.studio.nebius.ai/v1/`
- Token Factory: `https://api.tokenfactory.nebius.com/v1/`
- Swagger: `https://api.studio.nebius.ai/docs`

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.studio.nebius.ai/v1/",
    api_key=os.environ["NEBIUS_API_KEY"],
)

resp = client.chat.completions.create(
    model="meta-llama/Meta-Llama-3.1-70B-Instruct",
    messages=[{"role": "user", "content": "Cześć"}],
)
```

```bash
curl https://api.studio.nebius.ai/v1/chat/completions \
  -H "Authorization: Bearer $NEBIUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Meta-Llama-3.1-70B-Instruct","messages":[{"role":"user","content":"Hello"}]}'
```

Działa z: OpenAI SDK, LangChain, Vercel AI SDK, LiteLLM, deep-research, instructor, dspy.

## Mocne strony

1. **EU sovereignty** — DC w Finlandii (Mäntsälä, Lappeenranta), Francji (Béthune), UK (Surrey). GDPR/NIS2/HIPAA/ISO 27001 wbudowane. Dla telco/fintech (Orange, BlueSoft) — argument nie do podważenia.
2. **OpenAI-compatible** — migracja istniejącego kodu w 3 minuty.
3. **Najlepsze stawki dla Llama 405B** — $1/$3 to praktycznie najtańszy frontier-class model.
4. **Tani self-hosting** — H100 za $2.95/h bez kolejki (do 8 GPU samoobsługowo).
5. **DeepSeek R1 dostępne** — alternatywa do Claude'a/o3-mini w workflow research/reasoning.

## Słabe strony

1. **Brak Claude'a / GPT-4** — to konkurencja. Jeśli potrzebujesz Anthropica → OpenRouter / Anthropic bezpośrednio.
2. **Mniejszy ekosystem** niż Together/Fireworks — mniej tutoriali, mniejsza społeczność na SO.
3. **Cold start** dla dedicated endpoints (Token Factory) — przy bardzo niskim ruchu dopłacasz do bezczynnego GPU.
4. **Marka "ex-Yandex"** — formalnie spinoff całkowicie odcięty (HQ NL, NASDAQ), ale w korpo procurement może wymagać tłumaczeń. Warto sprawdzić whitepaper "compliance & data flow" przed podpisaniem.
5. **Min commitment dla większych klastrów** (>8 GPU) — przez sales, nie samoobsługa.

## Konkurenci

| Provider | Mocne | Słabe | Kiedy wybrać |
|---|---|---|---|
| **Nebius** | EU + OpenAI-compat + tani H100 + 405B za $1/$3 | mniejszy ekosystem | EU, sovereignty, custom hosting |
| **Together.ai** | fine-tuning friendly, dużo modeli | US-based | jeśli musisz tunować |
| **Fireworks** | najszybsza latencja, Multi-LoRA | US-based, Mixtral $3/M | latency-critical |
| **Replicate** | per-second billing, łatwe deploy | drogie dla LLM, US-based | sporadyczne joby, image gen |
| **OpenRouter** | aggregator, jeden klucz na wszystko | +5% marży, brak fine-tune | prototypowanie, multi-model |
| **Lambda / RunPod** | tani bare GPU | brak managed inference | DIY training |
| **Hyperscalers (AWS/GCP)** | wszystko obok | drogie, długie kolejki na H100 | gdy już tam jesteś |

## Use case'y w moim kontekście

1. **`mr_analizer`** — analiza tekstu MR-ów: Llama 3.1 8B/70B na Nebius (~$0.02–0.40/M). Tani i EU-resident (jeśli MR-y są wrażliwe).
2. **`deep-research` fork** — DeepSeek R1 zamiast OpenAI o3-mini. Tańsze, niezłe wyniki na reasoning.
3. **Embeddings dla MkDocs search** — embedding endpoint na Nebius zamiast OpenAI, dane zostają w UE.
4. **Fine-tuning eksperymenty** — H100 za $1.92/h (3-mies. commit) do trenowania custom modelu na konwencjach kodu.

## Źródła

- [Nebius — strona główna](https://nebius.com/)
- [Nebius AI Studio](https://nebius.com/ai-studio)
- [Nebius Token Factory](https://nebius.com/services/token-factory)
- [AI Studio pricing](https://nebius.com/prices-ai-studio)
- [GPU pricing](https://nebius.com/prices)
- [Token Factory API docs](https://docs.tokenfactory.nebius.com/api-reference/introduction)
- [AI Studio API docs](https://docs.nebius.com/studio/inference)
- [Swagger UI](https://api.studio.nebius.ai/docs)
- [GDPR FAQ](https://docs.nebius.com/legal/digital-rights/gdpr-compliance-faqs)
- [LiteLLM — Nebius integration](https://docs.litellm.ai/docs/providers/nebius)
- [Token Factory launch — businesswire](https://www.businesswire.com/news/home/20251105549683/en/Nebius-Launches-Nebius-Token-Factory-to-Deliver-Production-AI-Inference-at-Scale)
- [Europe's Hidden Sovereign AI Gem — Interconnected blog](https://interconnected.blog/europes-hidden-sovereign-ai-gem-nebius/)
- [10 Best Nebius Alternatives — Spheron](https://www.spheron.network/blog/nebius-alternatives/)
- [AI Inference API Providers Compared 2026 — Infrabase](https://infrabase.ai/blog/ai-inference-api-providers-compared)
