# export REGION=
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

# gsutil -m cp -r gs://spls/gsp067/python-docs-samples ../materials

cd ../materials/python-docs-samples/appengine/standard_python3/hello_world

# sed -i "s/python37/python39/g" app.yaml

gcloud app create --region=$REGION

# yes | gcloud app deploy

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#