
echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

cd ./labs/gsp412

bq mk ecommerce

bq query --use_legacy_sql=false \
"
#standardSQL
# how many products are on the website?
SELECT DISTINCT
productSKU,
v2ProductName
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
" &

bq query --use_legacy_sql=false \
"
#standardSQL
# find the count of unique SKUs
SELECT
DISTINCT
productSKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
" &

bq query --use_legacy_sql=false \
"
SELECT
v2ProductName,
COUNT(DISTINCT productSKU) AS SKU_count,
STRING_AGG(DISTINCT productSKU LIMIT 5) AS SKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE productSKU IS NOT NULL
GROUP BY v2ProductName
HAVING SKU_count > 1
ORDER BY SKU_count DESC
" &

bq query --use_legacy_sql=false \
"
SELECT
productSKU,
COUNT(DISTINCT v2ProductName) AS product_count,
STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE v2ProductName IS NOT NULL
GROUP BY productSKU
HAVING product_count > 1
ORDER BY product_count DESC
" &

bq query --use_legacy_sql=false \
"
SELECT DISTINCT
v2ProductName,
productSKU
FROM \`data-to-insights.ecommerce.all_sessions_raw\`
WHERE productSKU = 'GGOEGPJC019099'
" &

bq query --use_legacy_sql=false \
"
SELECT
SKU,
name,
stockLevel
FROM \`data-to-insights.ecommerce.products\`
WHERE SKU = 'GGOEGPJC019099'
" &

bq query --use_legacy_sql=false \
"
SELECT DISTINCT
website.v2ProductName,
website.productSKU,
inventory.stockLevel
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE productSKU = 'GGOEGPJC019099'
" &

bq query --use_legacy_sql=false \
"
WITH inventory_per_sku AS (
SELECT DISTINCT
website.v2ProductName,
website.productSKU,
inventory.stockLevel
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
JOIN \`data-to-insights.ecommerce.products\` AS inventory
ON website.productSKU = inventory.SKU
WHERE productSKU = 'GGOEGPJC019099'
)

SELECT
productSKU,
SUM(stockLevel) AS total_inventory
FROM inventory_per_sku
GROUP BY productSKU
" &

./bigquery.sh
./bigquery.sh
./bigquery.sh


echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"