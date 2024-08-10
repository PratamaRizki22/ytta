cd ../../../materials/python-docs-samples/appengine/standard_python3/hello_world


cat > main.py <<'EOF_END'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'Hello World!'

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)

EOF_END

gcloud app create --region=$REGION --project $PROJECT_ID

# yes | gcloud app deploy --project $PROJECT_ID

sed -i 's/Hello World!/'"$MESSAGE"'/g' main.py

yes | gcloud app deploy --project $PROJECT_ID