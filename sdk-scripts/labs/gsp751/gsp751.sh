#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

cd ./labs/gsp751

export GOOGLE_CLOUD_PROJECT=$PROJECT_ID
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/adc.json
export USER_EMAIL=$(gcloud auth list --format "value(ACCOUNT)")
cp /home/aguzztn54/.config/gcloud/legacy_credentials/$USER_EMAIL/adc.json ./adc.json

# git clone https://github.com/terraform-google-modules/terraform-google-network

./task1.sh & ./task2.sh & wait

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#