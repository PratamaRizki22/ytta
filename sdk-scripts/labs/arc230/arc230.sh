
echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

cd ./labs/arc230/functions

gcloud functions deploy cf-demo \
  --gen2 \
  --runtime go122 \
  --entry-point HelloHTTP \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --project $PROJECT_ID
  
echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"