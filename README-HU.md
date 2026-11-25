# SmartPrice Germany — Produktvergleich MVP

## Fokus dieses Releases
Die Produktpreisvergleichs-Phase hat Vorrang. Der Tankstellenbereich ist sichtbar als spätere Ausbaustufe markiert.

## Dateien
- `index.html`: responsives Produktvergleich-Frontend mit Kategorien, Suche, Sortierung, Verfügbarkeitsfilter und externen Preisvergleichslinks.
- `worker.js`: sicherer API-Endpunkt-Skeleton. Zeigt bewusst keine Preise, bis freigegebene Händlerfeeds verbunden sind.
- `schema.sql`: Cloudflare D1 Datenmodell für Produkte und Händlerangebote.

## Warum keine Live-Preise eingebaut sind
Es gibt keinen universellen, kostenlosen und uneingeschränkt weiterverwendbaren Feed mit allen deutschen Shops und Preisen. Wir dürfen daher keine Preisangaben durch Scraping oder ungeprüfte Drittanbieter-Daten vortäuschen.

## Priorisierte Datenquellen / Vertriebsweg
1. Händler-Affiliate-Netzwerke und Produktdatenfeeds mit ausdrücklicher Erlaubnis zum Preisvergleich.
2. Direkte Händlerpartnerschaften mit CSV/XML/JSON-Feeds.
3. Amazon PartnerNet / PA API erst nach Aufnahme ins Programm und Erfüllung der deutschen Preissuchmaschinen-Anforderungen.
4. Idealo: die offizielle Schnittstelle dient Händlern zur Übermittlung ihrer eigenen Angebotsdaten an idealo; sie ist nicht automatisch ein öffentlicher Feed, mit dem SmartPrice fremde idealo-Angebote abrufen darf.

## Quellen und wichtige Bedingungen
- Amazon PA API requirements: https://partnernet.amazon.de/help/node/topic/GVJ2BJP35457CLML
- Amazon German price comparison rules: https://partnernet.amazon.de/help/operating/policies/
- idealo technical integration: https://partner.idealo.com/partner-idealo-com/uk/learning-center/faq-technical-integration
- Google Product / Offer structured data: https://developers.google.com/search/docs/appearance/structured-data/merchant-listing?hl=de

Amazon requires current price/availability to be served by Amazon or retrieved via its approved API under the license. Its German price-comparison requirements can include displaying lowest new and, if supplied, lowest used price. Review all current terms before joining.

## Offer validation rules
- Match exact variants with GTIN/EAN where possible; otherwise use brand + manufacturer model + variant attributes.
- Never merge different capacities, sizes, colors, bundles or refurbished/new condition.
- Total comparison price = item price + mandatory shipping.
- Currency must be EUR for this Germany release.
- Save source, source record ID, fetch timestamp, expiry, and merchant URL.
- Exclude expired, malformed, unauthorized, duplicate or inconsistent offers.
- If no valid source offer remains, show “keine verifizierten Angebote” rather than a stale price.
- Show membership prices separately from generally available prices.
- Do not imply a displayed price is guaranteed at checkout.

## Next implementation milestones
1. Identify 3–5 merchants / affiliate networks that explicitly allow product feed display on a price comparison site.
2. Apply and obtain written approval.
3. Obtain feed/API credentials.
4. Build one adapter (CSV/XML/JSON) for the first approved partner.
5. Import into D1 with validation and expiry.
6. Enable `/api/products` only after real licensed feed data is present.
7. Add price history and alerts after data coverage is sufficient.

No retailer scraping, anti-bot bypass, or unauthorized copying is implemented.


## Nyelvválasztás
- Alapértelmezett nyelv: német.
- A látogató egyéni nyelvválasztása: német vagy magyar.
- A választás az adott böngészőben `localStorage` segítségével megmarad.
- Ez jelenleg eszközönkénti preferencia; felhasználói fiók és több eszköz közötti szinkronizálás későbbi funkció.
