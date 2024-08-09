echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

cd ./labs/gsp153

sshpass -p P@ssw0rd gcloud compute scp command.cmd demouser@windows-instance:C:/Users/demouser --zone=$ZONE --project $PROJECT_ID
# sshpass -p P@ssw0rd gcloud compute ssh demouser@windows-instance --zone=$ZONE --command="C:/Users/demouser/command.cmd"

sshpass -p P@ssw0rd gcloud compute ssh demouser@windows-instance --zone=$ZONE --project $PROJECT_ID --command=<<'EOF_END'
md my-windows-app\content
cd my-windows-app

call > Dockerfile

echo FROM hello-world > Dockerfile

docker build -t gcr.io/dotnet-atamel/iis-site-windows .
docker images
EOF_END

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"