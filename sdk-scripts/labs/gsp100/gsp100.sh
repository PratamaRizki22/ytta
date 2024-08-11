#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

# gcloud config set compute/zone $ZONE

# gcloud container clusters create lab-cluster \
#     --machine-type=e2-medium \
#     --zone=$ZONE \
#     --project $PROJECT_ID

gcloud container clusters get-credentials lab-cluster --project $PROJECT_ID --zone $ZONE

kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0

kubectl expose deployment hello-server --type=LoadBalancer --port 8080

# sleep 70

gcloud container clusters delete lab-cluster --project $PROJECT_ID --zone $ZONE

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#