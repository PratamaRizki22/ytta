

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gcloud compute instances create dev-instance \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-standard-2 \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=http-server \
    --create-disk=auto-delete=yes,boot=yes,image=projects/debian-cloud/global/images/family/debian-11,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any &

gcloud compute firewall-rules create allow-http --action=ALLOW \
    --direction=INGRESS \
    --description "Allow HTTP traffic" \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server \
    --project=$PROJECT_ID

# sleep 20

cd ./labs/gsp183

run_command(){
    # gcloud compute scp command.sh $USER@dev-instance:/tmp --project="$PROJECT_ID" --zone="$ZONE"
    gcloud compute ssh $USER@dev-instance --project="$PROJECT_ID" --zone="$ZONE" --command=<<'EOF_END'
sudo apt-get update
sudo apt-get install git -y
sudo apt-get install python3-setuptools python3-dev build-essential -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
python3 --version
pip3 --version
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.3/python/devenv ~/devenv
cd ~/devenv/
sudo python3 server.py
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


echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"