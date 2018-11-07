#!/bin/bash

function jsonFormat {
    temp="$(echo "{$fileContent}" | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $param)"
    echo "GET : ${temp##*|}"
}

jsonPath=$1
dbName=$2
dbCollection=$3

autoImp(){
    mongoimport -d $dbName -c $dbCollection --file temp.json --jsonArray
}

echo $jsonPath

for filename in $jsonPath/*.json; do
  fileContent="$( cat $filename )"
  id="$(echo "${filename}" | rev | cut -d"/" -f1  | rev)"
  bId="$(echo "${id}" | rev | cut -d"." -f2-  | rev)"
  echo "bId = ${bId}"

  nbFlower="$(echo "{$fileContent}" | grep bloomy_id | wc -l |  sed "s/\   //g")"
  echo "nbFlower = ${nbFlower}"

  flowerName="$(echo "{$fileContent}"| grep name | sed "s/\\\u00a0/ /g" | sed "s/\"name\": \"//g" | sed 's/-.*//' | sed 's/".*//' | sed "s/\      //g")"

  flowerList="\"Flowers\":["
  while read -r line; do
      flowerList+="\"$line\","
  done <<< "$flowerName"
  flowerList=${flowerList%,}
  flowerList+="]"


  JsonBouquet="[{\"id\":\"$bId\",nbFlowers:\"$nbFlower\",$flowerList}]"
  echo "${JsonBouquet}" > temp.json
  autoImp
done
