# export PROJECT_ID="$(gcloud config get-value project)"         

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-bucket

gsutil cp ./labs/gsp277/demo-image.jpg gs://$PROJECT_ID-bucket/demo-image.jpg

gsutil acl ch -u allUsers:R gs://$PROJECT_ID-bucket/demo-image.jpg

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"
