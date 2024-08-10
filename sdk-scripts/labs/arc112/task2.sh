# gcloud compute scp ./labs/arc112/prepare_disk.sh lab-setup:/tmp --project=$PROJECT_ID --zone=$ZONE

gcloud compute ssh $USER@lab-setup --project=$PROJECT_ID --zone=$ZONE --command=<<'EOF_END'
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world
EOF_END