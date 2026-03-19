# Serwis wysyłki maili dla Claude

**TL;DR:** Postawić lokalny serwis mailowy, przez który Claude mógłby wysyłać maile na prośbę użytkownika z konta SebastianZuk.ai.asystent. Integracja przez API lub CLI.

## Motywacja

Możliwość wysyłania maili z poziomu Claude Code — np. podsumowania, powiadomienia, raporty. Dedykowane konto (ai.asystent) jasno oznacza, że mail pochodzi od asystenta AI.

## Analiza podejść

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

## Rekomendacja

**Etap 1:** Zacząć od `msmtp` lub prostego skryptu Python — minimalne, działa od razu.
**Etap 2:** Jeśli potrzeba historii/logów — Flask mikroserwis z SQLite do logowania wysłanych maili.

## Konfiguracja konta

- Utworzyć konto Google `SebastianZuk.ai.asystent@gmail.com` (lub subdomena własnej domeny)
- Wygenerować App Password (Google → Security → 2FA → App Passwords)
- Przechowywać credentials w `~/.config/mail-agent/` z uprawnieniami `600`

## Bezpieczeństwo

- Claude wysyła maile **wyłącznie na wyraźną prośbę** użytkownika
- Warto dodać whitelist dozwolonych odbiorców lub wymagać potwierdzenia przed wysyłką
- Logować każdą wysyłkę (kto, kiedy, do kogo, temat)
