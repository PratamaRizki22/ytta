echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

gcloud sql instances create myinstance \
    --database-version=POSTGRES_15 \
    --tier=db-custom-2-7680 \
    --region=$REGION \
    --storage-type=SSD \
    --storage-size=250GB \
    --project=$PROJECT_ID
    
echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"