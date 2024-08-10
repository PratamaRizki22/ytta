
#----------------------------------------------------start--------------------------------------------------#

echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"
export REGION="${ZONE%-*}"

cd ./labs/arc112

./task1.sh
./task2.sh & ./task3.sh



echo "${BG_RED}${BOLD}Congratulations For Completing The Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#