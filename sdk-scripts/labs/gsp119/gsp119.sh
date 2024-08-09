
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')
cd ./labs/gsp119

run_command(){
  # gcloud compute scp command.sh $USER@linux-instance:/tmp --zone=$ZONE
gcloud compute ssh $USER@linux-instance --zone=$ZONE --project=$PROJECT_ID --command=<<'EOF_END'
enable_service(){
    gcloud services enable apikeys.googleapis.com
}
lib_enabled=false
while [ "$lib_enabled" = false ]; do
	if enable_service; then
		echo "API ENABLED, continuing.."
		lib_enabled=true
	else
		echo "Retrying to Enable Required APIs..."
	fi
done

gcloud alpha services api-keys create --display-name="awesome" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

cat > request.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-tests/speech/brooklyn.flac"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
EOF_END
}

success=false
while [ "$success" = false ]; do
  if run_command; then
    echo "SSH Connection Success, Executing Commands"
    success=true
  else
    echo "Waiting for Connections"
  fi
done

echo "${YELLOW}${BOLD}NOW${RESET}" "${WHITE}${BOLD}Check The Score${RESET}" "${GREEN}${BOLD}${RESET}"