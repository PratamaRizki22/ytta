# export PROJECT_ID=$(gcloud info --format='value(config.project)')

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"


cd ./labs/gsp091

export ZONE=us-east1-c

gcloud config set compute/zone $ZONE

./task1-3-4.sh & ./task2-5.sh

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"