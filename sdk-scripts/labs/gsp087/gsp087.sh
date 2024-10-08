
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting Execution ${RESET}"

gcloud storage buckets create gs://$PROJECT_ID --project $PROJECT_ID

gcloud storage cp -r gs://spls/gsp087/* gs://$PROJECT_ID --project $PROJECT_ID

echo "${GREEN}${BOLD}Task 2 Completed${RESET}" &

gcloud compute instance-templates create autoscaling-instance01 \
    --project $PROJECT_ID \
    --metadata=startup-script-url=gs://$PROJECT_ID/startup.sh,gcs-bucket=gs://$PROJECT_ID


echo "${GREEN}${BOLD}Task 3 Completed ${RESET}" &

gcloud beta compute instance-groups managed create autoscaling-instance-group-1 \
    --project=$PROJECT_ID \
    --base-instance-name=autoscaling-instance-group-1 \
    --size=1 \
    --template=projects/$PROJECT_ID/global/instanceTemplates/autoscaling-instance01 \
    --zone=$ZONE \
    --list-managed-instances-results=PAGELESS \
    --no-force-update-on-repair \
    --default-action-on-vm-failure=repair 
    
gcloud beta compute instance-groups managed set-autoscaling autoscaling-instance-group-1 \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --cool-down-period=60  \
    --max-num-replicas=3 \
    --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.6 \
    --stackdriver-metric-filter=resource.type\ =\ \"gce_instance\" \
    --update-stackdriver-metric=custom.googleapis.com/appdemo_queue_depth_01 \
    --stackdriver-metric-utilization-target=150.0 \
    --stackdriver-metric-utilization-target-type=gauge

echo "${GREEN}${BOLD} Task 4 & 7  Completed Lab Completed !!! ${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#