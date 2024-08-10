cd ./monolith-to-microservices/microservices/src/orders

gcloud builds submit --tag gcr.io/${PROJECT_ID}/$ORD_IDENT:1.0.0 .  --project $PROJECT_ID

kubectl create deployment $ORD_IDENT --image=gcr.io/${PROJECT_ID}/$ORD_IDENT:1.0.0

kubectl expose deployment $ORD_IDENT --type=LoadBalancer --port 80 --target-port 8081