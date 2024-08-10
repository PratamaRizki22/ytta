cd ../materials/pet-theory/lab06/firebase-rest-api/solution-01

# npm install
gcloud builds submit --tag gcr.io/$PROJECT_ID/rest-api:0.1 --project $PROJECT_ID


deploy_function() {
    yes | gcloud beta run deploy $SERVICE_NAME --region=$REGION \
        --image gcr.io/$PROJECT_ID/rest-api:0.1 \
        --allow-unauthenticated \
        --project $PROJECT_ID
}
deploy_success=false

while [ "$deploy_success" = false ]; do
    if deploy_function; then
        echo "Build Success"
        deploy_success=true
    else
        echo "Failed to Build, Retrying ...."
    fi
done