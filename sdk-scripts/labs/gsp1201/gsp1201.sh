#!/bin/bash
# Define color variables
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

cd ./labs/gsp1201

# gcloud storage cp -R gs://spls/gsp1201/chat-flask-cloudrun . --project $PROJECT_ID

export AR_REPO='chat-app-repo'
export SERVICE_NAME='chat-flask-app'

./task2.sh &

gcloud run deploy "$SERVICE_NAME" \
    --region=$REGION \
    --project=$PROJECT_ID \
    --port=8080 \
    --image="us-docker.pkg.dev/cloudrun/container/hello" \
    --allow-unauthenticated \
    --platform=managed \
    --execution-environment=gen2

export deploy_url=$(gcloud run services list --project $PROJECT_ID --filter $SERVICE_NAME --format "value(URL)")

# python3 -m webbrowser $deploy_url

timeout 120 bash -c -- 'while true; do curl $deploy_url; sleep $((RANDOM % 4)) ; done'

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#