#!/bin/bash
# Define color variables

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

cd ./labs/gsp185

# gcloud app create --region $REGION --project $PROJECT_ID;

gcloud config set project $PROJECT_ID

gsutil mb gs://$PROJECT_ID-media
gsutil cp Google_Cloud_Storage_logo.png gs://$PROJECT_ID-media
gsutil rm -r gs://$PROJECT_ID-media
gsutil mb gs://$PROJECT_ID-media
gsutil rm -r gs://$PROJECT_ID-media
gsutil mb gs://$PROJECT_ID-media

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#