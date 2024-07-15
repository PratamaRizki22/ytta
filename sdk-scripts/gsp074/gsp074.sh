# export REGION=

#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gcloud config set compute/region $REGION

# export PROJECT_ID=$(gcloud projects list --format='value(PROJECT_ID)' \
#   --filter='qwiklabs-gcp')

gsutil mb gs://$PROJECT_ID

# curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

gsutil cp ./gsp074/ada.jpg gs://$PROJECT_ID

gsutil cp -r gs://$PROJECT_ID/ada.jpg .

gsutil cp gs://$PROJECT_ID/ada.jpg gs://$PROJECT_ID/image-folder/

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/ada.jpg

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#