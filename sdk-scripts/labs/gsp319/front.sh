cd ./monolith-to-microservices/microservices/src/frontend

gcloud builds submit --tag gcr.io/${PROJECT_ID}/$FRONT_IDENT:1.0.0 . --project $PROJECT_ID

kubectl create deployment $FRONT_IDENT --image=gcr.io/${PROJECT_ID}/$FRONT_IDENT:1.0.0

kubectl expose deployment $FRONT_IDENT --type=LoadBalancer --port 80 --target-port 8080