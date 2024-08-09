echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gcloud compute instances create sqlserver-lab --zone=$ZONE \
	--project=$PROJECT_ID \
	--machine-type=e2-medium \
	--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
	--metadata=enable-oslogin=true,gce-initial-windows-password=P@ssw0rd,gce-initial-windows-user=demouser \
	--maintenance-policy=MIGRATE \
	--provisioning-model=STANDARD \
	--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
	--create-disk=auto-delete=yes,boot=yes,device-name=sqlserver-lab,image=projects/windows-sql-cloud/global/images/sql-2016-web-windows-2016-dc-v20240711,mode=rw,size=50,type=pd-balanced \
	--no-shielded-secure-boot \
	--shielded-vtpm \
	--shielded-integrity-monitoring \
	--labels=goog-ec-src=vm_add-gcloud \
	--reservation-affinity=any

reset_password() {
	yes | gcloud compute reset-windows-password sqlserver-lab --zone=$ZONE --project $PROJECT_ID
}
reset_success=false

while [ "$reset_success" = false ]; do
  if reset_password; then
    echo "New Password applied. Exiting the loop."
    reset_success=true
  else
    echo "Retrying Password Reset..."
  fi
done


echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"