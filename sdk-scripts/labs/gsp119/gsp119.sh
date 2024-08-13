
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')
cd ./labs/gsp119

./create-key.sh & ./ssh-connect.sh & wait

echo "${YELLOW}${BOLD}NOW${RESET}" "${WHITE}${BOLD}Check The Score${RESET}" "${GREEN}${BOLD}${RESET}"