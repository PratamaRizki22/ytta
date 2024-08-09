
echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

cd ./labs/arc232/functions

gcloud functions deploy cf-demo \
    --gen2 \
    --entry-point=HelloWorld.Function \
    --runtime=dotnet6 \
    --region=$REGION \
    --source=. \
    --trigger-http \
    --allow-unauthenticated \
    --project $PROJECT_ID

    
echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"