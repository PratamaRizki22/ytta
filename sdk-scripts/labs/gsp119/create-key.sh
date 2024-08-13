enable_service(){
    gcloud services enable apikeys.googleapis.com --project $PROJECT_ID
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

gcloud alpha services api-keys create --display-name="awesome" --project $PROJECT_ID