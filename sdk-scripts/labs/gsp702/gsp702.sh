
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# git clone https://github.com/GoogleCloudPlatform/DIY-Tools.git
cd ./labs/gsp702

gcloud firestore import gs://$PROJECT_ID-firestore/prd-back --project $PROJECT_ID

PROJECT_NUMBER=$(gcloud projects list --filter="PROJECT_ID=$PROJECT_ID" --format="value(PROJECT_NUMBER)")
SERVICE_ACCOUNT_EMAIL="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role "roles/artifactregistry.reader" \
    --project $PROJECT_ID

./cloudrun.sh &

# ===================================== TASK 3 =========================================

./gcf.sh &

#  ====================================== TASK 4 ==================================== 
./appengine.sh


echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#