#!/bin/bash
# Define color variables
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gcloud config set project $PROJECT_ID
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

# git clone https://github.com/GoogleCloudPlatform/golang-samples.git
# cd golang-samples/functions/functionsv2/hellostorage/
cd ./labs/arc236/functions

deploy_function() {
    gcloud functions deploy cf-demo \
        --runtime=go121 \
        --region="$REGION" \
        --source=. \
        --entry-point=HelloStorage \
        --trigger-bucket="$PROJECT_ID-bucket"

}

# Loop until the Cloud Function is deployed
while true; do
	# Run the deployment command
	deploy_function

	# Check if Cloud Function is deployed
	if gcloud functions describe cf-demo --region "$REGION" &> /dev/null; then
		echo "Cloud Function is deployed. Exiting the loop."
		break
	else
		echo "Waiting for Cloud Function to be deployed..."
	fi
done

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#