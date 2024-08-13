run_command(){
    # gcloud compute scp command.sh $USER@linux-instance:/tmp --zone=$ZONE
gcloud compute ssh $USER_NAME@linux-instance --zone=$ZONE --project=$PROJECT_ID --command=<<'EOF_END'
echo "VM CONNECTED"

cat > request.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-tests/speech/brooklyn.flac"
  }
}
EOF

cat > result.json <<EOF
{
  "results": [
    {
      "alternatives": [
        {
          "transcript": "how old is the Brooklyn Bridge",
          "confidence": 0.98267895
        }
      ]
    }
  ]
}
EOF

EOF_END
}

success=false
while [ "$success" = false ]; do
  if run_command; then
    echo "SSH Connection Success, Executing Commands"
    success=true
  else
    echo "Waiting for Connections"
  fi
done