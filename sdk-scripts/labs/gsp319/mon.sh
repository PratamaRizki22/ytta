cd ./monolith-to-microservices/monolith

gcloud builds submit --tag gcr.io/${PROJECT_ID}/${MON_IDENT}:1.0.0 . --project $PROJECT_ID

kubectl create deployment $MON_IDENT --image=gcr.io/${PROJECT_ID}/$MON_IDENT:1.0.0

kubectl expose deployment $MON_IDENT --type=LoadBalancer --port 80 --target-port 8080