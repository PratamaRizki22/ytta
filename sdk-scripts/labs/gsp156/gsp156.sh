#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

# gcloud auth list 
cd ./labs/gsp156

gcloud compute instances create terraform --project $PROJECT_ID \
    --zone $ZONE \
    --machine-type e2-medium \
    --create-disk=auto-delete=yes,boot=yes,device-name=terraform,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240709,mode=rw,size=10,type=pd-balanced

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#