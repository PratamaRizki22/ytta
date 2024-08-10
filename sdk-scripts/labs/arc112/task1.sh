enable_service(){
	gcloud services enable appengine.googleapis.com --project $PROJECT_ID
}
lib_enabled=false

while [ "$lib_enabled" = false ]; do
	if enable_service; then
		echo "App Engine API enabled"
		lib_enabled=true
	else
		echo "Retrying to Enable App engine services..."
	fi
done