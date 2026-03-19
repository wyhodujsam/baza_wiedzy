---
tags:
  - python
  - flask
  - tailscale
  - ai
---

# claude-remote

> **TL;DR:** Mobilny web UI do Claude Code CLI. Dostępny przez Tailscale z telefonu.

- **Katalog:** ~/claude-remote
- **Stack:** Python 3.12, Flask
- **Port:** 8080
- **Uruchomienie:** usługa systemd (user)
- **Usługa:** `systemctl --user status claude-remote`
- **Autostart:** tak (systemd + linger)
- **Restart po awarii:** tak (co 5s)

Streamuje odpowiedzi przez SSE (Server-Sent Events).

## Zarządzanie

```bash
systemctl --user start claude-remote
systemctl --user stop claude-remote
systemctl --user restart claude-remote
systemctl --user status claude-remote
journalctl --user -u claude-remote -f  # logi
```
