-- SmartPrice Germany product offer schema (Cloudflare D1 / SQLite)
-- Populate only from partner feeds whose license explicitly permits comparison display.
CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY,
  gtin TEXT,
  brand TEXT,
  model TEXT,
  title TEXT NOT NULL,
  variant TEXT,
  category TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_products_gtin ON products(gtin);

CREATE TABLE IF NOT EXISTS offers (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  merchant_id TEXT NOT NULL,
  merchant_name TEXT NOT NULL,
  item_price_cents INTEGER NOT NULL CHECK(item_price_cents >= 0),
  shipping_price_cents INTEGER NOT NULL CHECK(shipping_price_cents >= 0),
  currency TEXT NOT NULL DEFAULT 'EUR',
  availability TEXT,
  condition TEXT NOT NULL DEFAULT 'new',
  product_url TEXT NOT NULL,
  source_name TEXT NOT NULL,
  source_record_id TEXT,
  fetched_at TEXT NOT NULL,
  valid_until TEXT NOT NULL,
  is_authorized INTEGER NOT NULL CHECK(is_authorized = 1),
  FOREIGN KEY(product_id) REFERENCES products(id)
);
CREATE INDEX IF NOT EXISTS idx_offers_product_valid ON offers(product_id, valid_until);
CREATE INDEX IF NOT EXISTS idx_offers_fetched ON offers(fetched_at);

-- Never return an offer after its validity window.
-- Sort by full cost, not item price alone.
CREATE VIEW IF NOT EXISTS current_offers AS
SELECT o.*, (o.item_price_cents + o.shipping_price_cents) AS total_price_cents
FROM offers o
WHERE o.is_authorized = 1
  AND datetime(o.valid_until) > datetime('now');
