# export ZONE_1=
# export ZONE_2=
# export ZONE_3=

#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

export REGION_1=${ZONE_1%-*}
export REGION_2=${ZONE_2%-*}
export REGION_3=${ZONE_3%-*}

gcloud compute networks create taw-custom-network --subnet-mode custom

gcloud compute networks subnets create subnet-$REGION_1 \
    --network taw-custom-network \
    --region $REGION_1 \
    --range 10.0.0.0/16 &

gcloud compute networks subnets create subnet-$REGION_2 \
    --network taw-custom-network \
    --region $REGION_2 \
    --range 10.1.0.0/16 &

gcloud compute networks subnets create subnet-$REGION_3 \
    --network taw-custom-network \
    --region $REGION_3 \
    --range 10.2.0.0/16 &

wait


gcloud compute networks subnets list \
    --network taw-custom-network &

gcloud compute firewall-rules create nw101-allow-http \
    --allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
    --target-tags http &

gcloud compute firewall-rules create "nw101-allow-icmp" --allow icmp --network "taw-custom-network" --target-tags rules &

gcloud compute firewall-rules create "nw101-allow-internal" --allow tcp:0-65535,udp:0-65535,icmp --network "taw-custom-network" --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16" &

gcloud compute firewall-rules create "nw101-allow-ssh" --allow tcp:22 --network "taw-custom-network" --target-tags "ssh" &

gcloud compute firewall-rules create "nw101-allow-rdp" --allow tcp:3389 --network "taw-custom-network" &

wait

gcloud compute instances create us-test-01 \
    --subnet subnet-$REGION_1 \
    --zone $ZONE_1 \
    --machine-type e2-standard-2 \
    --tags ssh,http,rules &

gcloud compute instances create us-test-02 \
    --subnet subnet-$REGION_2 \
    --zone $ZONE_2 \
    --machine-type e2-standard-2 \
    --tags ssh,http,rules &

gcloud compute instances create us-test-03 \
    --subnet subnet-$REGION_3 \
    --zone $ZONE_3 \
    --machine-type e2-standard-2 \
    --tags ssh,http,rules &

wait

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#