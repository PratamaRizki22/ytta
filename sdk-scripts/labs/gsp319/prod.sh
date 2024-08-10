cd ./monolith-to-microservices/microservices/src/products

gcloud builds submit --tag gcr.io/${PROJECT_ID}/$PROD_IDENT:1.0.0 . --project $PROJECT_ID

kubectl create deployment $PROD_IDENT --image=gcr.io/${PROJECT_ID}/$PROD_IDENT:1.0.0

kubectl expose deployment $PROD_IDENT --type=LoadBalancer --port 80 --target-port 8082