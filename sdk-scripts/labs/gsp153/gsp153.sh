echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

sshpass -p P@ssw0rd gcloud compute ssh demouser@windows-instance --zone=$ZONE

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"