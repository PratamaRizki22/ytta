
cd ./labs/gsp090

TOKEN=$(gcloud auth print-access-token)

# ===================================== TASK1: Create 2nd VM ===================================
gcloud compute instances create instance2 \
    --zone $ZONE \
    --machine-type e2-standard-2 \
    --tags ssh,http,rules \
    --project=$PROJECT_ID_2 &

gcloud beta monitoring metrics-scopes create projects/$PROJECT_ID --project $PROJECT_ID_2

# ================================ TASK 2 : Create Monitoring Group ==============================
# Koyoe enek bug, kudu manual ngeklik "Create Group", lek ora ngono ora iso checklist
group_id=""
group_created=false
while [ "$group_created" = false ]; do
    group_str=$(curl -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{
        "parentName": "",
        "displayName": "DemoGroup",
        "isCluster": false,
        "filter": "resource.metadata.name=has_substring(\"instance\")"
    }' \
    "https://monitoring.googleapis.com/v3/projects/${PROJECT_ID_2}/groups" | jq .name)

	if [ "$group_str" != "" ]; then 
        group_id_str=(${group_str//projects\/"${PROJECT_ID_2}"\/groups\//})
        group_id=$(echo $group_id_str | bc)
        echo $group_id
		group_created=true
    	echo "DemoGroup Created, now go to --> https://console.cloud.google.com/monitoring/groups/$group_id/edit?project=$PROJECT_ID_2 and click Save!"
	else
    	echo "Trying to create DemoGroup Monitoring Group..."
	fi
done


# ===================================== TASK 3 : Create Uptime check =============================

uptime_id=$(gcloud monitoring uptime create "DemoGroup uptime check" \
    --group-id $group_id \
    --port 22 \
    --protocol tcp \
    --period 1 \
    --project=$PROJECT_ID_2 \
    | grep -oE "(demogroup([-a-zA-Z0-9]+))")

# ======================================== Task 4 : Create Alert =================================

cat > policy.json <<EOF_CP
{
    "displayName": "Uptime Check Policy",
    "combiner": "OR",
    "enabled": true,
    "conditions": [
        {
            "displayName": "Uptime Condition",
            "conditionAbsent": {
                "filter": "resource.type=\"gce_instance\" AND metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"$uptime_id\" AND group.id=\"$group_id\"",
                "duration": "300s",
                "aggregations": [
                    {
                        "alignmentPeriod": "300s"
                    }
                ]
            }
        }
    ]
}
EOF_CP

policy_created=false
while [ "$policy_created" = false ]; do
	if gcloud alpha monitoring policies create --policy-from-file="policy.json" --project $PROJECT_ID_2; then 
		policy_created=true
    	echo "Alert Policy Created"
	else
    	echo "Trying to create alert policy..."
	fi
done