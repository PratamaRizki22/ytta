# ============ TASK 2 ========================
gcloud container clusters create gmp-cluster --num-nodes=1 --zone us-east1-c

cluster_ready=false
while [ "$cluster_ready" = false ]; do
	isrunning=$(gcloud container clusters list --format='value(STATUS)')
	if [ "$isrunning" == "RUNNING" ]; then 
		cluster_ready=true
    	echo "Cluster Created"
	else
    	echo "Waiting for Cluster to be created..."
	fi
done

gcloud container clusters get-credentials gmp-cluster

kubectl create ns gmp-test

kubectl -n gmp-test apply -f https://storage.googleapis.com/spls/gsp091/gmp_flask_deployment.yaml

kubectl -n gmp-test apply -f https://storage.googleapis.com/spls/gsp091/gmp_flask_service.yaml

kubectl get services -n gmp-test

# ===========================  TASK 5 ===============================

timeout 120 bash -c -- 'while true; do curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')/error; sleep $((RANDOM % 4)) ; done'