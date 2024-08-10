cd ./DIY-Tools/gcp-data-drive

build_function(){
    gcloud builds submit --config cloudbuild_gcf.yaml \
        --project $PROJECT_ID \
        --no-source \
        --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"
}

build_success=false
while [ "$build_success" = false ]; do
  if build_function; then
    echo "Build Success. Exiting the loop."
    build_success=true
  else
    echo "Trying to build to be created..."
  fi
done


gcloud alpha functions add-iam-policy-binding gcp-data-drive \
    --member=allUsers \
    --role=roles/cloudfunctions.invoker \
    --project $PROJECT_ID

export CF_TRIGGER_URL=$(gcloud functions describe gcp-data-drive --project $PROJECT_ID --format="value(httpsTrigger.url)")

curl $CF_TRIGGER_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .

curl $CF_TRIGGER_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes