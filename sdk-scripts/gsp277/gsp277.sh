#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# APIs Explorer: Qwik Start

export PROJECT_ID="$(gcloud config get-value project)"         

gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-bucket

# curl -LO raw.githubusercontent.com/QUICK-GCP-LAB/2-Minutes-Labs-Solutions/main/APIs%20Explorer%20Qwik%20Start/demo-image.jpg

gsutil cp ./gsp277/demo-image.jpg gs://$PROJECT_ID-bucket/demo-image.jpg

gsutil acl ch -u allUsers:R gs://$PROJECT_ID-bucket/demo-image.jpg

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#