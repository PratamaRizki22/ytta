#!/bin/bash

export BLACK=`tput setaf 0`
export RED=`tput setaf 1`
export GREEN=`tput setaf 2`
export YELLOW=`tput setaf 3`
export BLUE=`tput setaf 4`
export MAGENTA=`tput setaf 5`
export CYAN=`tput setaf 6`
export WHITE=`tput setaf 7`

export BG_BLACK=`tput setab 0`
export BG_RED=`tput setab 1`
export BG_GREEN=`tput setab 2`
export BG_YELLOW=`tput setab 3`
export BG_BLUE=`tput setab 4`
export BG_MAGENTA=`tput setab 5`
export BG_CYAN=`tput setab 6`
export BG_WHITE=`tput setab 7`

export BOLD=`tput bold`
export RESET=`tput sgr0`

# If NodeJS is installed on the system where you run the script, use this
# node browser-automation.js &

# If NodeJS is installed on Windows but you're using WSL to run the script, ensure it's set to your path.
"/mnt/c/Program Files/nodejs/node.exe" browser-automation.js &


# Initializing Google Cloud SDK
gcloud init --skip-diagnostics

# Declare Lab Variables
while IFS='=' read -ra line; do
    key=${line[0]}
    value=${line[1]}
    declare "$key"="$value"
    export "$key"
done < variables.txt 

# REPlACE WITH YOUR LAB ID
LABID=""   # example => gsp016

./${LABID}/${LABID}.sh