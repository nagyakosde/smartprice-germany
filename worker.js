// SmartPrice Germany — product API skeleton (Cloudflare Worker)
// Intentionally returns no prices until a licensed merchant feed is configured.
// Never scrape shops or invent fallback offers.
export default {
 async fetch(request, env) {
  const url=new URL(request.url);
  if(url.pathname!=="/api/products"||request.method!=="GET")return new Response("Not found",{status:404});
  const q=(url.searchParams.get("q")||"").trim();
  if(q.length<2||q.length>120)return json({ok:false,message:"Bitte einen Suchbegriff mit 2 bis 120 Zeichen eingeben."},400);
  // Future: query normalized offers in Cloudflare D1, populated only by authorized partner feeds.
  // Required fields per offer: gtin, title, merchant, item_price, shipping_price,
  // total_price, currency, availability, product_url, source, fetched_at, valid_until.
  if(!env.PRODUCT_FEEDS_ENABLED)return json({ok:false,message:"Noch keine freigegebene Händler-Datenquelle verbunden. Preise werden deshalb nicht angezeigt."},503);
  // Do not enable until a licensed feed adapter and validation pipeline are deployed.
  return json({ok:false,message:"Produktdatenbank ist noch nicht live geschaltet."},503);
 }
};
function json(data,status=200){return new Response(JSON.stringify(data),{status,headers:{"Content-Type":"application/json; charset=utf-8","Cache-Control":"no-store","Access-Control-Allow-Origin":"*"}});}
