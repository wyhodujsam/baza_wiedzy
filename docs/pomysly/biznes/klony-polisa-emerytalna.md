# Klony jako "polisa emerytalna" — pomysł biznesowy

**Data zapisu:** 2026-04-22
**Status:** pomysł wstępny, research w toku

## Koncept

Na posiadanej działce (~4ha) posadzić plantację klonów. Sprzedawać pojedyncze drzewa klientom jako długoterminową "polisę emerytalną":

- **Opłata początkowa** — klient "kupuje" drzewo (przypisane imiennie, z numerem/geolokalizacją)
- **Roczna opłata utrzymaniowa** — pielęgnacja, przycinanie, ubezpieczenie, monitoring
- **Część rocznej opłaty = mój zysk operacyjny**
- **Wypłata** — po X latach drewno idzie na sprzedaż (meble, instrumenty, fornir); klient dostaje udział w zysku

## Założenia do weryfikacji (research)

1. **Klony prowadzone właściwie mają mało sęków** — prawda?
2. **Drewno klonowe jest ognioodporne** — prawda? Jakie parametry?
3. **Można je przycinać nawet 4 razy** (w cyklu życia? w roku?) — sporo drewna do odzysku z przycinek
4. **Czas wzrostu** do rozmiaru sprzedażnego (średnica pnia, wysokość)
5. **Ceny sprzedaży** — za sztukę / za m³ / za kłodę fornirową
6. **Gatunek** — jawor (Acer pseudoplatanus)? klon zwyczajny (Acer platanoides)? cukrowy (A. saccharum)? inny?

## Komponent softwarowy

Aplikacja do:
- **Sprzedaży** — sklep/konfigurator, umowa, płatności cykliczne (subskrypcja roczna)
- **Monitoringu dla klienta** — lokalizacja drzewa, zdjęcia okresowe, historia pielęgnacji, wzrost, prognoza wartości
- **Zarządzania plantacją** — CRUD drzew, harmonogram prac, finanse, raportowanie
- **Rozliczenia końcowego** — wycena, udział klienta w zysku ze sprzedaży drewna

Stack: Java/Spring Boot (zgodnie z preferencjami) + React/Vue front + PostgreSQL + mapa (geolokalizacja drzew).

## Ryzyka (wstępne)

- **Horyzont czasowy** — jeśli klon dojrzewa 40-80 lat, to "polisa emerytalna" dla 30-latka OK, ale model cashflow długi
- **Ryzyka plantacji** — pożar, choroby, szkodniki, wichury → **ubezpieczenie** konieczne
- **Regulacje** — ustawa o lasach, wycinka, KOWR, VAT od usług pielęgnacyjnych, prospekt emisyjny (czy to nie produkt inwestycyjny wymagający KNF?)
- **Ryzyko prawne** — "polisa emerytalna" to termin regulowany; trzeba nazwać inaczej (np. "Twoje drzewo", "drzewny udział")
- **Płynność** — klient chce wyjść wcześniej → rynek wtórny / odkup

## Research — wyniki (2026-04-22)

### 1. Sęki i technika formowania pnia — POTWIERDZONE

- Technika nazywa się **podkrzesywanie** (poprawianie formy drzew / pruning).
- Polega na usuwaniu dolnych gałęzi tak, by górne partie pnia rosły jako drewno **bezsęczne** (czysty sortyment).
- Standardowo stosowana w Polsce dla dębu, buka, jesionu, świerka, sosny, modrzewia, jodły. Klon jawor — rzadziej, ale drewno ma wysoką wartość.
- Start: ok. 10 cm pierśnicy, 10–12 m wysokości. Najpierw do 4–5 m, potem do 8 m (nie redukując korony >1/4).
- "4 razy przycinać" = prawdopodobnie 2–4 fazy podkrzesywania rozłożone w cyklu życia plantacji. **Przycinki rocznej biomasy to nie jest źródło wartościowego drewna** — to odpad/opał (max 200–300 zł/m³).
- Źródło: [Lasy Państwowe — podkrzesywanie](https://www.lasy.gov.pl/pl/edukacja/slownik/p/podkrzesywanie), [Encyklopedia Leśna](https://www.encyklopedia.lasypolskie.pl/doku.php?id=p:poprawianie-formy-drzew), [AgForward – Formowanie drzew PDF](https://agrolesnictwo.pl/wp-content/uploads/2021/03/10_Dobra_praktyka_Formowanie_drzew.pdf)

### 2. Ognioodporność — CZĘŚCIOWO / MIT

- Drewno klonowe to twardy liściasty (hardwood), gęstość Acer saccharum ~700 kg/m³, twardość Janka 6450 lbf.
- Niestety **żadne drewno naturalne nie jest "ognioodporne"** w klasie A. Typowe drewna mają Flame Spread Index 90–160 (Class C/III). Drewna gęstsze (dąb, klon, buk) palą się wolniej niż sosna/świerk, ale to nadal jest materiał palny.
- Marketing "ognioodporne" wymagałby impregnacji lub byłby półprawdą. **Nie używać tego argumentu.**
- Źródło: [FPL USDA — Fire Performance of Hardwood Species](https://www.fpl.fs.usda.gov/documnts/pdf2000/white00c.pdf), [AWC DCA1 Flame Spread](https://awc.org/wp-content/uploads/2021/12/AWC-DCA1-FlameSpreadPerformance-1906.pdf)

### 3. Czas wzrostu — DŁUGI HORYZONT

- **Klon jawor (Acer pseudoplatanus)**: żyje 250–300 lat, rekordowe 500. Przyrost młodych 50–100 cm/rok (wysokość). Rotacja gospodarcza na drewno tartaczne zwykle **80–120 lat**, na drewno fornirowe premium 100–140 lat.
- **Klon cukrowy (Acer saccharum)**: w PL rośnie wolniej niż w naturalnym zasięgu (Kanada/USA). Rotacja do pierwszego syropu klonowego ~30–40 lat, na drewno 70–100 lat.
- **Realny horyzont dla "polisy emerytalnej"**: min. 30 lat do pierwszych cięć pielęgnacyjnych z wartością, 60–80 lat do pełnego wyrębu. Model cashflow musi to uwzględnić.
- Źródło: [EUFORGEN — Acer pseudoplatanus PL](https://www.euforgen.org/fileadmin/templates/euforgen.org/upload/Countries/Poland/Technical_guidelines/Acer_pseudoplatanus_POL.pdf), [atlas-roslin.pl](https://www.atlas-roslin.pl/gatunki/Acer_pseudoplatanus.htm), [drzewa.com.pl — klon cukrowy](https://www.drzewa.com.pl/klon-cukrowy.html)

### 4. Ceny sprzedaży — PRZEDZIAŁY

Brak publicznych cenników Lasów Państwowych dla klonu klasy W (nadleśnictwa mają lokalne), ale:

| Sortyment | Cena (PLN/m³) | Uwagi |
|---|---|---|
| Drewno opałowe (zrębki, przycinki) | 200–400 | Rynek masowy, niska marża |
| Drewno tartaczne standard (klon klasa S/W II–III) | 800–1 500 | Meblarskie |
| Kłoda fornirowa klon jawor klasa W I (czysty pień bezsęczny) | 3 000–8 000 | Meble premium, intarsje |
| Jawor "płomienisty" / "pawie oczko" / rezonansowy (instrumenty) | 10 000–30 000+ | Skrajnie rzadkie, rynek lutniczy |

**Kalkulacja na drzewo** (realna, konserwatywna):
- Plantacja 4 ha przy 400–600 drzew/ha = 1 600–2 400 drzew (docelowo po trzebieżach zostanie ~200–400).
- Dojrzały pień klonu po 70 latach: 1–2 m³ drewna tartacznego + ewentualnie 0,5–1 m³ kłody fornirowej z dolnej części pnia.
- Wartość pojedynczego drzewa w wyrębie: **3 000–15 000 zł** (mediana ok. 5 000–8 000 zł dobrze prowadzonego drzewa).
- Źródło: [cenniki Lasów Państwowych — Nadleśnictwa Giżycko/Płaska/Łąck](https://gizycko.bialystok.lasy.gov.pl/aktualnosci/-/asset_publisher/1M8a/content/cennik-drewna), [ofertadrewna.pl](https://ofertadrewna.pl/drewno-okragle/)

### 5. Regulacje — UWAGA

- **Nie nazywać "polisą"** — termin zastrzeżony (ustawa o działalności ubezpieczeniowej, KNF). Sugestie: "Twoje Drzewo", "Drzewny Depozyt", "Plantacja Pokoleń", "SadMarkowy".
- Jeśli oferta trafi do >149 osób z obietnicą zysku → może być **oferta publiczna** wymagająca memorandum informacyjnego lub prospektu KNF. **Konsultacja prawna obowiązkowa** przed skalowaniem.
- Konstrukcja bezpieczniejsza: umowa **dzierżawy/depozytu** + **umowa usług pielęgnacyjnych** (oddzielnie). Klient nie kupuje "udziału w zysku", tylko konkretne drzewo + usługę.
- VAT: sprzedaż drewna 8% (produkt rolny), usługi pielęgnacyjne 23%.
- Źródło: [KNF — przewodnik prospektowy](https://www.knf.gov.pl/knf/pl/komponenty/img/Przewodnik_prospektowy.pdf), [KNF — Q&A oferty publiczne](https://www.knf.gov.pl/podmioty/Podmioty_rynku_kapitalowego/Oferty_Publiczne_i_Prospekty_Emisyjne/Q&A_dot_ofert_publicznych_i_prospektow)

## Wnioski wstępne

**Plusy pomysłu:**
- Klon (jawor) faktycznie daje wartościowe drewno, można formować bezsęczne pnie, jest popyt na fornir premium.
- 4 ha to realna skala na 1 500–2 000 drzew docelowych — sensowny portfel.
- "Emerytalny" timing pasuje: klient 30–40 lat → wypłata po 30–40 latach.

**Minusy / korekty:**
- Zapomnij o "ognioodporności" jako argumencie sprzedażowym — to mit.
- Horyzont 60–80 lat na pełną wypłatę jest realny, 30 lat → tylko częściowe trzebieże.
- "Polisa emerytalna" = problem regulacyjny. Zmienić framing.
- Ryzyko: pożar, choroby (np. rak klonu), wichury → ubezpieczenie **krytyczne**.
- Cashflow: pierwszy wartościowy dochód z przerzedzania ok. 25–35 roku. Do tego czasu firma żyje wyłącznie z rocznych opłat utrzymaniowych.

**Kierunek modelu biznesowego:**
- Opłata wejściowa: 1 500–3 000 zł / drzewo (pokrycie sadzonki, sadzenia, geolokalizacji, rejestracji)
- Roczna opłata: 150–300 zł / drzewo (pielęgnacja, ubezpieczenie, monitoring, marża)
- Przy 1 500 drzewach i śr. 200 zł/rok = **300 000 zł/rok** przychodu stałego → realnie pokrywa operację + zysk.
- Wypłata końcowa: 50–70% wartości drewna dla klienta, 30–50% dla prowadzącego.

**Następne kroki:**
1. Rozmowa z dendrologiem / leśnikiem praktyczącym podkrzesywanie klonu
2. Konsultacja prawna (KNF + prawo podatkowe + ustawa o lasach)
3. Sprawdzić analogi: "Las mój las", niemieckie ForestFinance, ekwadorskie crowdfundingi lasowe
4. Wstępny model finansowy (Excel) — IRR dla klienta, NPV dla nas, break-even
5. Dopiero potem MVP aplikacji (Java/Spring Boot + React + mapa z geolokalizacją drzew)

