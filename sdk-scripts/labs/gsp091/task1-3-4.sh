gcloud beta monitoring channels create --type "email" \
	--description "This is an Email Notification Channel"\
	--channel-labels "email_address=$USER_EMAIL" \
	--display-name "myEmail"

export channel_id=$(gcloud beta monitoring channels list | grep -oP 'name: \K[^ ]+' | head -n 1)

# ================================= TASK 1 ===================

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

policy_created=false
while [ "$policy_created" = false ]; do
	if gcloud alpha monitoring policies create --policy-from-file="task1-policy.json"; then 
		policy_created=true
    	echo "Alert Policy Created"
	else
    	echo "Trying to create alert policy..."
	fi
done

# ============================ TASK 3 =======================
# curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')/metrics

gcloud logging metrics create hello-app-error \
	--description="Hello Decription" \
	--log-filter="severity=ERROR AND resource.labels.container_name=\"hello-app\" AND textPayload: \"ERROR: 404 Error page not found\""

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

policy_created=false
while [ "$policy_created" = false ]; do
	if gcloud alpha monitoring policies create --policy-from-file="task4-policy.json"; then 
		policy_created=true
    	echo "Alert Policy Created"
	else
    	echo "Trying to create alert policy..."
	fi
done