#!/bin/bash
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

cd ./labs/gsp184/start

# virtualenv -p python3 vrenv
source vrenv/bin/activate
# pip install -r requirements.txt
# pip install grpcio

export GCLOUD_PROJECT=$PROJECT_ID

cp /home/aguzztn54/.config/gcloud/legacy_credentials/$USER_EMAIL/adc.json ./adc.json

gcloud app create --region $REGION --project $PROJECT_ID

"/mnt/c/Program Files/nodejs/node.exe" ../browser-runner.js & python run_server.py 

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#