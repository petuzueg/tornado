#!/bin/bash
scripts="/var/www/tornado.generalshop.ru/scripts"
CLIENT_ID=20
CLIENT_SECRET=NMR3IhtBPVYXqqNVZlQJ97wXgc6Ap9W4n5QHSSa3

access_token_file="${scripts}/kolobox/access_token.txt"         # Get file with a name access_token
ACCESS_TOKEN=$(cat "$access_token_file") # Read the file to variable

refresh_token_file="${scripts}/kolobox/refresh_token.txt"         # Get file with a name access_token
REFRESH_TOKEN=$(cat "$refresh_token_file") # Read the file to variable

query="grant_type=refresh_token&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&username=mail@generalshop.ru&password=mkolobox&refresh_token=${REFRESH_TOKEN}"
# echo $query

NEW_REFRESH_TOKEN=$(curl -sd "${query}" https://okno2.kolobox.ru/api/oauth/token )
refresh_token=$(echo $NEW_REFRESH_TOKEN  | jq -r '.refresh_token')
access_token=$(echo $NEW_REFRESH_TOKEN  | jq -r '.access_token')

# Write both tokens to the files.
echo "${access_token}" > ${scripts}/kolobox/access_token.txt
echo "${refresh_token}" > ${scripts}/kolobox/refresh_token.txt
