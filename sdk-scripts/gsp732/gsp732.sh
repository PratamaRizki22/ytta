# export REGION=

export PROJECT_ID=$(gcloud projects list --format='value(PROJECT_ID)' \
--filter='qwiklabs-gcp')

gcloud services enable servicedirectory.googleapis.com

gcloud service-directory namespaces create example-namespace \
   --location $REGION

gcloud service-directory services create example-service \
   --namespace example-namespace \
   --location $REGION

gcloud dns managed-zones create example-zone-name \
   --dns-name myzone.example.com \
   --description "Example Zone Description" \
   --visibility private \
   --gkeclusters ""  &


gcloud service-directory endpoints create example-endpoint \
   --address 0.0.0.0 \
   --port 80 \
   --service example-service \
   --namespace example-namespace \
   --location $REGION
