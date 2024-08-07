
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

cd ./labs/gsp416
./fruit.sh & ./racing.sh & wait

# echo '[
#     {
#         "name": "race",
#         "type": "STRING",
#         "mode": "NULLABLE"
#     },
#     {
#         "name": "participants",
#         "type": "RECORD",
#         "mode": "REPEATED",
#         "fields": [
#             {
#                 "name": "name",
#                 "type": "STRING",
#                 "mode": "NULLABLE"
#             },
#             {
#                 "name": "splits",
#                 "type": "FLOAT",
#                 "mode": "REPEATED"
#             }
#         ]
#     }
# ]' > schema.json


echo "${GREEN}${BOLD}Task 9. Filter within array values Completed${RESET}"

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#