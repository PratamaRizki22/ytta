#!/bin/bash
echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

gcloud pubsub topics create myTopic

gcloud  pubsub subscriptions create --topic myTopic mySubscription

echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"