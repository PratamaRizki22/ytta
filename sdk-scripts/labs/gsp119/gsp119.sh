
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')
cd ./labs/gsp119

run_command(){
  gcloud compute scp command.sh linux-instance:/tmp --zone=$ZONE
  gcloud compute ssh linux-instance --zone=$ZONE --command="bash /tmp/command.sh"
}

success=false
while [ "$success" = false ]; do
  if run_command; then
    echo "SSH Connection Success, Executing Commands"
    success=true
  else
    echo "Waiting for Connections"
    sleep 1
  fi
done

echo "${YELLOW}${BOLD}NOW${RESET}" "${WHITE}${BOLD}Check The Score${RESET}" "${GREEN}${BOLD}${RESET}"