
echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

gcloud config set compute/zone $ZONE

# # ============== TASK 2 =================
gcloud container clusters create hello-world --num-nodes=2 --zone=$ZONE

# ====================== TASK 3 ===================

# cd ./materials

# gsutil -m cp -r gs://spls/gsp022/mongo-k8s-sidecar .

cd ../materials/mongo-k8s-sidecar/example/StatefulSet/

kubectl apply -f googlecloud_ssd.yaml

# ====================== TASK 4 ========================

# nano mongo-statefulset.yaml
# Remove - "--smallfiles"
# Remove - "--noprealloc"

kubectl apply -f mongo-statefulset.yaml


# ==================== TASK 5 ================================
kubectl get statefulset

task_5_ok=false
while [ "$task_5_ok" = false ]; do
    kubectl get pod
	pod_num=$(kubectl get pod --field-selector=status.phase=Running --output json | jq -j '.items | length')

	if [ "$pod_num" == 3 ]; then 
		task_5_ok=true
        echo "${GREEN} Statefulset Complete ${RESET}"
	else
    	echo "Scaling Cluster, Waiting....."
        sleep 2
	fi
done

# =========================== TASK 6 =========================
kubectl scale --replicas=5 statefulset mongo


scale_5_ok=false
while [ "$scale_5_ok" = false ]; do
    kubectl get pod
	scale_num=$(kubectl get pod --field-selector=status.phase=Running --output json | jq -j '.items | length')

	if [ "$scale_num" == 5 ]; then 
		scale_5_ok=true
        echo "${GREEN} Cluster scaled to 5 ${RESET}"
	else
    	echo "Scaling Cluster, Waiting....."
        sleep 2
	fi
done

kubectl get pods

kubectl scale --replicas=3 statefulset mongo

sleep 5

kubectl get pods


echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"