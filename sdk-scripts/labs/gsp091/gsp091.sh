# export PROJECT_ID=$(gcloud info --format='value(config.project)')

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"


cd ./labs/gsp091

gcloud config set compute/zone us-east1-c
gcloud container clusters create gmp-cluster --num-nodes=1 --zone us-east1-c &

gcloud beta monitoring channels create --type "email" \
	--description "This is an Email Notification Channel"\
	--channel-labels "email_address=$USER_EMAIL" \
	--display-name "myEmail" &
wait

channel_info=$(gcloud beta monitoring channels list)
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)


cat > task1-policy.json <<EOF_CP
{
    "displayName": "stopped vm",
    "conditions": [
        {
            "displayName": "VM Instance - Stop Instance",
            "conditionMatchedLog": {
                "filter": "resource.type=\"gce_instance\" AND protoPayload.methodName=\"v1.compute.instances.stop\""
            }
        }
    ],
    "notificationChannels": ["$channel_id"],
    "combiner": "OR",
    "enabled": true,
    "alertStrategy": {
        "notificationRateLimit": {
            "period": "300s"
        },
        "autoClose": "3600s"
    }
}
EOF_CP

gcloud alpha monitoring policies create --policy-from-file="task1-policy.json"


# gcloud compute instances stop instance1

# ============ TASK 2 ========================

cluster_ready=false
while [ "$cluster_ready" = false ]; do
	isrunning=$(gcloud container clusters list --format='value(STATUS)')
	if [ "$isrunning" == "RUNNING" ]; then 
		cluster_ready=true
    	echo "Cluster Created"
	else
    	echo "Waiting for Cluster to be created..."
		sleep 2
	fi
done

gcloud container clusters get-credentials gmp-cluster &

kubectl create ns gmp-test & wait

kubectl -n gmp-test apply -f https://storage.googleapis.com/spls/gsp091/gmp_flask_deployment.yaml

kubectl -n gmp-test apply -f https://storage.googleapis.com/spls/gsp091/gmp_flask_service.yaml

kubectl get services -n gmp-test


# ======================== TASK 3 ==========================

curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')/metrics

gcloud logging metrics create hello-app-error \
	--description="Hello Decription" \
	--log-filter="severity=ERROR AND resource.labels.container_name=\"hello-app\" AND textPayload: \"ERROR: 404 Error page not found\"" &

# ============================ TASK4 ========================

cat > task4-policy.json <<EOF_CP
{
    "displayName": "log based metric alert",
    "conditions": [
        {
            "displayName": "metric alert",
            "conditionThreshold": {
                "filter": "resource.type=\"metric\" AND metric.type=\"logging.googleapis.com/user/hello-app-error\"",
                "aggregations": [
                    {
                        "alignmentPeriod": "120s",
                        "crossSeriesReducer": "REDUCE_NONE",
                        "perSeriesAligner": "ALIGN_RATE"
                    }
                ],
                "comparison": "COMPARISON_GT",
                "thresholdValue": 1000,
                "duration": "0s"
            }
        }
    ],
    "notificationChannels": ["$channel_id"],
    "combiner": "OR",
    "enabled": true
}
EOF_CP

gcloud alpha monitoring policies create --policy-from-file="task4-policy.json"

# ===========================  TASK 5 ===============================

timeout 120 bash -c -- 'while true; do curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')/error; sleep $((RANDOM % 4)) ; done'


echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"