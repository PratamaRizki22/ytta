#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

export SERVICE_NAME=netflix-dataset-service

export FRNT_STG_SRV=frontend-staging-service

export FRNT_PRD_SRV=frontend-production-service

service_enabled=false;
while [ "$service_enabled" = false ]; do
  if gcloud services enable run.googleapis.com --project $PROJECT_ID; then
    echo "Cloud Run Enabled"
    service_enabled=true
  else
    echo "Waiting for Cloud Run service to be enabled..."
  fi
done


gcloud firestore databases create --location=$REGION --project $PROJECT_ID

# git clone https://github.com/rosera/pet-theory.git

./labs/gsp344/gsp344-1.sh &
./labs/gsp344/gsp344-2.sh 
./labs/gsp344/gsp344-3.sh

SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --platform=managed --project $PROJECT_ID --region=$REGION --format="value(status.url)")

# curl -X GET $SERVICE_URL/2019

cd ../materials/pet-theory/lab06/firebase-frontend/public

cat > app.js <<'EOF_END'
function setTileData(items) {
    const dynamicView = items.map((item) => {
        return `<tr>
        <td>${item.title}</td>
        <td>${item.type}</td>
        <td>${item.rating}</td>
        <td>${item.director}</td>
        <td>${item.duration}</td>
        <td>${item.date_added}</td>
      </tr>`;
    });

    let header = `<div class="table-wrapper">
    <table>
      <thead>
      <tr>
        <th>Title</th>
        <th>Type</th>
        <th>Rating</th>
        <th>Director</th>
        <th>Duration</th>
        <th>Date</th>
      </thead><tbody>`;

    let footer = `</tbody></table>
		</div>`;

    return header + dynamicView.join('') + footer;
}

async function fetchLocalData(file) {
    try {
        const response = await fetch(file);
        const local = await response.json();
        return local;
    } catch (error) {
        console.log(`Fetch: ${error}`);
    }
}

async function getPageInfo() {
    const info = await fetchLocalData(REST_API_SERVICE);
    htmlContent = document.querySelector('#info');
    htmlContent.innerHTML = setTileData(info.content);
}

window.addEventListener('load', () => {
    getPageInfo();
});
EOF_END

sed -i "1i const REST_API_SERVICE = \"$SERVICE_URL/2020\"" app.js

cd ../

stagging () {
    gcloud builds submit --tag gcr.io/$PROJECT_ID/frontend-staging:0.1 --project $PROJECT_ID
    yes | gcloud beta run deploy $FRNT_STG_SRV \
        --image gcr.io/$PROJECT_ID/frontend-staging:0.1 \
        --region=$REGION \
        --project $PROJECT_ID

}

prod () {
    gcloud builds submit --tag gcr.io/$PROJECT_ID/frontend-production:0.1 --project $PROJECT_ID
    yes | gcloud beta run deploy $FRNT_PRD_SRV \
        --image gcr.io/$PROJECT_ID/frontend-production:0.1 \
        --region=$REGION \
        --project $PROJECT_ID

}

stagging & prod

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#