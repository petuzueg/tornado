#!/bin/bash
path="/var/www/tornado.generalshop.ru"
script_path="${path}/scripts"
path="${path}/web/sites/default/files/feeds"

#VIANOR
# Get Vianor prices.
wget 'https://b2b.vianor-tyres.ru/online/catalog/store.xml?token=d1bcdd79f51587cd1dccf4ec43c6db51&tire=true&wheel=true&truck-tire=true&truck-wheel=true' -O ${path}/tmp/vianor-catalog_unprocessed.xml

# SHINSERVICE
wget -O "${path}/csv/shinservice-b2b-tyres.csv" https://duplo.shinservice.ru/xml/shinservice-b2b-tyres.csv?id=88888893 &
t=1650515678844

# KOLOBOX
# Импорт всех шин для словарей
wget -O "${path}/xml/kolobox-tyres.xml" https://okno2.kolobox.ru/storage/catalog/tyres.xml

# Get access token from file
file="${script_path}/kolobox/access_token.txt" # Get file with a name access_token
token=$(cat "$file")                           # Read the file to variable

header='Authorization: Bearer '$token

seq=$(perl -e "$,=' ';print 0..90")
for i in $seq; do
#  if [ $i == 50]; then
    sleep 1
#  else
    wget -O "${script_path}/kolobox/page${i}" --no-check-certificate --quiet \
      --method GET \
      --timeout=0 \
      --header "$header" \
      'https://okno2.kolobox.ru/api/catalog/tyres/'$i'?onstock=only_available'
#  fi
done

# Join all the kolobox files.
jq -s 'add' ${script_path}/kolobox/page* >"${path}/json/kolobox.json"
