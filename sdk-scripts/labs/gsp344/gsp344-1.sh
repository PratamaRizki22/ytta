cd ../materials/pet-theory/lab06/firebase-import-csv/solution
# npm install


cat > .env <<EOF_CP
GOOGLE_CLOUD_PROJECT=$PROJECT_ID
GOOGLE_APPLICATION_CREDENTIALS=adc.json
EOF_CP

csv_run(){
  cp /home/aguzztn54/.config/gcloud/legacy_credentials/$USER_EMAIL/adc.json ./adc.json
  "/mnt/c/Program Files/nodejs/node.exe" index.js netflix_titles_original.csv
}
run_success=false

while [ "$run_success" = false ]; do
  if csv_run; then
    echo "Populate Database Success"
    run_success=true
  else
    echo "Failed to populate Firestore Database, Retrying ...."
  fi
done