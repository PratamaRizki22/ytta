bq query --use_legacy_sql=false \
"
SELECT
productSKU,
ARRAY_AGG(DISTINCT v2ProductName) AS push_all_names_into_array
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE productSKU = 'GGOEGAAX0098'
GROUP BY productSKU
" &

bq query --use_legacy_sql=false \
"
SELECT
productSKU,
ARRAY_AGG(DISTINCT v2ProductName LIMIT 1) AS push_all_names_into_array
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE productSKU = 'GGOEGAAX0098'
GROUP BY productSKU
" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT DISTINCT
website.productSKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# pull ID fields from both tables
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.SKU AS inventory_SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
# IDs are present in both tables, how can you dig deeper?
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# the secret is in the JOIN type
# pull ID fields from both tables
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.SKU AS inventory_SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
LEFT JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# find product SKUs in website table but not in product inventory table
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.SKU AS inventory_SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
LEFT JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE inventory.SKU IS NULL
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# you can even pick one and confirm
SELECT * FROM \`data-to-insights.ecommerce.products\`
WHERE SKU = 'GGOEGATJ060517'
# query returns zero results
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# reverse the join
# find records in website but not in inventory
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.SKU AS inventory_SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
RIGHT JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# what are these products?
# add more fields in the SELECT STATEMENT
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.*
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
RIGHT JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL
" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT DISTINCT
website.productSKU AS website_SKU,
inventory.SKU AS inventory_SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
FULL JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE website.productSKU IS NULL OR inventory.SKU IS NULL
" &

bq query --use_legacy_sql=false \
"
#standardSQL
CREATE OR REPLACE TABLE ecommerce.site_wide_promotion AS
SELECT .05 AS discount;
" &

bq query --use_legacy_sql=false \
"
SELECT DISTINCT
productSKU,
v2ProductCategory,
discount
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%'
" &

bq query --use_legacy_sql=false \
"
INSERT INTO ecommerce.site_wide_promotion (discount)
VALUES (.04),
(.03);
" &

bq query --use_legacy_sql=false \
"
SELECT discount FROM ecommerce.site_wide_promotion
" &

bq query --use_legacy_sql=false \
"
SELECT DISTINCT
productSKU,
v2ProductCategory,
discount
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%'
" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT DISTINCT
productSKU,
v2ProductCategory,
discount
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%'
AND productSKU = 'GGOEGOLC013299'
" &
wait