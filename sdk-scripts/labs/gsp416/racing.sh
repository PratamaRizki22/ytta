
# Race  Resource
bq mk racing

bq mk --table --schema=schema.json --description "Table for race details" $PROJECT_ID:racing.race_results 

bq load --source_format=NEWLINE_DELIMITED_JSON --schema=schema.json $PROJECT_ID:racing.race_results gs://data-insights-course/labs/optimizing-for-performance/race_results.json

echo "${GREEN}${BOLD}Task 6. Practice with STRUCTs and arrays Completed${RESET}" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p
" &

echo "${GREEN}${BOLD}Task 7. Lab question: STRUCT() Completed${RESET}" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_times
WHERE p.name LIKE 'R%'
GROUP BY p.name
ORDER BY total_race_time ASC;
" &

echo "${GREEN}${BOLD}Task 8. Lab question: Unpacking arrays with UNNEST( ) Completed${RESET}" &

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  p.name,
  split_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
" &

wait
