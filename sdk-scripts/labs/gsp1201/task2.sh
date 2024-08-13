cd ./chat-flask-cloudrun

gcloud artifacts repositories create "$AR_REPO" \
    --location="$REGION" \
    --repository-format=Docker \
    --project $PROJECT_ID

gcloud builds submit --project $PROJECT_ID \
    --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" 