cd ./DIY-Tools/gcp-data-drive

gcloud builds submit --config cloudbuild_run.yaml \
    --project $PROJECT_ID \
    --no-source \
    --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"

gcloud beta run services add-iam-policy-binding \
    --region=$REGION \
    --member=allUsers \
    --role=roles/run.invoker gcp-data-drive \
    --project $PROJECT_ID

export CLOUD_RUN_SERVICE_URL=$(gcloud run services --platform managed describe gcp-data-drive --project $PROJECT_ID --region $REGION --format="value(status.url)")

curl $CLOUD_RUN_SERVICE_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .

curl $CLOUD_RUN_SERVICE_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes | jq .