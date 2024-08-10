cd ./DIY-Tools/gcp-data-drive

gcloud builds submit  --config cloudbuild_appengine.yaml \
    --project $PROJECT_ID \
    --no-source \
    --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"

export TARGET_URL=https://$(gcloud app describe --project $PROJECT_ID --format="value(defaultHostname)")

curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .

curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes | jq .

gcloud builds submit --config cloudbuild_gcf.yaml \
    --project $PROJECT_ID \
    --no-source \
    --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"

for ((i=1;i<=1000;i++));
do
   curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes > /dev/null &
done