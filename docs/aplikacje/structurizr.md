# structurizr

> **TL;DR:** Narzędzie do modelowania architektury (C4 model) w DSL. UI edytowalny w przeglądarce, workspace jako pliki `.dsl`/`.json`.

## Stack
- Obraz Docker: `structurizr/structurizr:latest` (tryb `local`)
- Następca deprecated **Structurizr Lite** (`structurizr/lite`)
- Workspace: pliki w `~/apps/structurizr/workspace/` (autosave co 5 s)

## Dostęp
- URL: <http://localhost:8087>
- Po wejściu redirect na `/workspace/1`
- Brak autoryzacji (`structurizr.authentication: none`)

## Uruchomienie
Kontener startuje automatycznie (`--restart unless-stopped`).

```bash
docker start structurizr      # ręczny start
docker stop structurizr       # zatrzymanie
docker logs structurizr       # logi
```

Pełna komenda `run` (jeśli trzeba odtworzyć):

```bash
docker run -d \
  --name structurizr \
  --restart unless-stopped \
  -p 8087:8080 \
  -v ~/apps/structurizr/workspace:/usr/local/structurizr \
  structurizr/structurizr:latest local
```

> **Uwaga:** katalog workspace musi być zapisywalny dla użytkownika z kontenera (`chmod -R 777 ~/apps/structurizr/workspace`).

## Workspace
Startowy plik `workspace.dsl` zawiera szkielet modelu ekosystemu aplikacji w `~/apps/` (Sebastian → kontenery: mr-analizer, traffic-simulator, public-goods-game, notes-app, mkdocs-kb, claude-remote).

Edycja:
- przez UI (Diagrams → DSL editor) — zmiany zapisywane do `workspace.dsl`
- bezpośrednio w pliku — po zapisie zrefreshuj stronę

## C4 model — szybka ściąga
- **Context** — system + użytkownicy + sąsiednie systemy
- **Container** — aplikacje/serwisy wewnątrz systemu
- **Component** — moduły wewnątrz kontenera
- **Code** — klasy/funkcje (rzadko używane)

## Linki
- Docs: <https://docs.structurizr.com/>
- DSL reference: <https://docs.structurizr.com/dsl>
- GitHub: <https://github.com/structurizr/structurizr>
