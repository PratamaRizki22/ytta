BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

# Automation for Login, Accept Terms and Condition, Proggress Checker
# node browser-automation.js &                                    # if NodeJS installed in Linux System
"/mnt/c/Program Files/nodejs/node.exe" browser-automation.js &    # If NodeJS installed in Windows, set to your path

gcloud init --skip-diagnostics                                    # SDK Login Command

# Manual Accept Terms and Conditions if you can't run browser automation
# python3 -m webbrowser https://console.cloud.google.com/terms/cloud

# Declare Lab Variables
while IFS='=' read -ra line; do
    key=${line[0]}
    value=${line[1]}
    declare "$key"="$value"
    export "$key"
done < variables.txt 


# Change labID
LABID=gsp016

./${LABID}/${LABID}.sh