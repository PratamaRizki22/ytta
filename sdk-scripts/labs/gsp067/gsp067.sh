
echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

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

# git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

cd ../materials/python-docs-samples/appengine/standard_python3/hello_world

cat > main.py <<'EOF_END'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'Hello, Cruel World!'

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)

EOF_END

gcloud app create --region $REGION --project $PROJECT_ID
yes | gcloud app deploy --project $PROJECT_ID

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"