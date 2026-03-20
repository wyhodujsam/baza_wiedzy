# Serwis wysyłki maili dla Claude

**Status:** :white_check_mark: Zrealizowane (2026-03-19)

**TL;DR:** Lokalny serwis mailowy przez `msmtp`, wysyłka z konta `sebastian.zuk.ai.asystent@gmail.com` na prośbę użytkownika.

## Realizacja

- **Wybrane podejście:** msmtp (opcja 4 z analizy poniżej)
- **Konto:** `sebastian.zuk.ai.asystent@gmail.com`
- **Konfiguracja:** `~/.msmtprc`
- **Credentials:** App Password w `~/.config/mail-agent/app-password` (uprawnienia 600)
- **Logi:** `~/.config/mail-agent/msmtp.log`
- **Wysyłka:** `echo -e "Subject: ...\nMIME-Version: 1.0\nContent-Type: text/plain; charset=UTF-8\n\nTreść" | msmtp adres@example.com`

## Motywacja

Możliwość wysyłania maili z poziomu Claude Code — np. podsumowania, powiadomienia, raporty. Dedykowane konto (ai.asystent) jasno oznacza, że mail pochodzi od asystenta AI.

## Analiza podejść (archiwalna)

### 1. SMTP relay + skrypt CLI (najprostsze)

- Skonfigurować konto `SebastianZuk.ai.asystent@gmail.com` (lub własna domena)
- Lokalny skrypt/tool CLI (`sendmail.sh` lub Python) wywołujący SMTP
- Claude wywołuje skrypt przez Bash
- **Plusy:** minimalne, zero zależności serwerowych, łatwe do debugowania
- **Minusy:** hasło/app password w pliku konfiguracyjnym, brak kolejki

### 2. Własny mikroserwis (Flask/FastAPI)

- Endpoint `POST /send` przyjmujący `to`, `subject`, `body`
- Backend łączy się z SMTP (Gmail, własny serwer, lub zewnętrzny provider)
- Claude wywołuje przez `curl` lub dedykowany tool
- **Plusy:** łatwe logowanie wysłanych maili, można dodać rate limiting, historia
- **Minusy:** kolejny serwis do utrzymania

### 3. Zewnętrzny provider API (Resend, Mailgun, SendGrid)

- API key + REST endpoint
- Nie trzeba konfigurować SMTP
- **Plusy:** niezawodność, deliverability, gotowe API
- **Minusy:** zależność od zewnętrznego serwisu, potencjalne koszty, dane wychodzą na zewnątrz

### 4. msmtp (lekki klient SMTP)

- `msmtp` — minimalistyczny klient SMTP w systemie
- Konfiguracja w `~/.msmtprc`, wysyłka przez `echo "treść" | msmtp adres@example.com`
- **Plusy:** zero kodu, instalacja jednym `apt install`, natywnie działa z pipe
- **Minusy:** brak historii wysłanych, brak UI

## Bezpieczeństwo

- Claude wysyła maile **wyłącznie na wyraźną prośbę** użytkownika
- Logi każdej wysyłki w `~/.config/mail-agent/msmtp.log`

