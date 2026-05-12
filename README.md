# Geschossflaeche-Update

Update- und Lizenz-Endpunkt für das **gf-Tool** (Geschossflächenberechnung
aus Bauantrags-PDFs).

## Inhalt

- **`version.txt`** — aktuell veröffentlichte stabile Version (x.y.z).
- **`allowlist.json`** — SHA-256-Hashes aller aktiven Lizenz-IDs
  (Präfix `GF-`). Wird lokal aus einer privaten `kunden.json` per
  `tools/build-allowlist.js` aus dem gf-Tool-Repo erzeugt.
- **`releases/`** — Release-ZIPs (`gf-tool-x.y.z.zip`), sobald veröffentlicht.

## Historie

Dieses Repo war bis Mai 2026 unter dem Namen `Vollgeschossberechnung-Update`
der Update-Endpunkt für das eigenständige Vollgeschoss-Tool. Mit der
Integration der Vollgeschoss-Funktionalität ins **gf-Tool** wurde es zu
`Geschossflaeche-Update` umbenannt und bedient nun das Nachfolger-Tool.
