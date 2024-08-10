#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"



enable_service(){
    gcloud services enable cloudbuild.googleapis.com container.googleapis.com --project $PROJECT_ID
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

# git clone https://github.com/googlecodelabs/monolith-to-microservices.git

# cd ~/monolith-to-microservices
# ./setup.sh

gcloud container clusters create $CLUSTER --num-nodes 3 --project $PROJECT_ID --zone $ZONE

cd ./labs/gsp319

./mon.sh &
./ord.sh & 
./prod.sh & 
./front.sh




echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#