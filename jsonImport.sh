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
  echo "[" > temp.json
  echo "[" > species.json
  while read p; do
    if builtin echo "{$p}" | grep bouquet;
    then
      flowerList+="]"
      flowerList="$( echo $flowerList | sed 's/,]/]/g')"
      JsonBouquet="{\"id\":\"$bId\",\"nbFlowers\":\"$nbFlower\",$flowerList},"
      echo $JsonBouquet >> temp.json
      bId="$(builtin echo "{$p}" | grep bouquet | sed 's/{\"bouquet\": \"//g' | sed 's/\",}//g')"
      nbFlower=0
      flowerList="\"Flowers\":["
    fi
    if builtin echo "{$p}" | grep species;
    then
      ((++nbFlower))
      flowerName="$(builtin echo "{$p}"| grep species | sed 's/{\"species\": //g' | sed 's/}}//g')"
      simpleFlowerName="$( echo $flowerName | sed 's/\"//g' |cut -d' ' -f1)" #-f1-N to keep n words

      grep -q -i "$simpleFlowerName" species.json
      if [ $? -eq 0 ]; then
         echo "Name Found"
      else
        newSpecies="{\"species\":\"$simpleFlowerName\"},"
        echo $newSpecies >> species.json
      fi

      flowerList="${flowerList}${flowerName},"
    fi

  done < $filename
  sed -i '.bak' '2d' temp.json
  sed -i '.bak' 's/,},\"/\",\"/g' temp.json
  sed -i '.bak' 's/,}/,}\"/g' temp.json
  sed -i '.bak' '$ s/.$//' temp.json
  sed -i '.bak' '$ s/.$//' species.json
  echo "]" >> temp.json
  echo "]" >> species.json
  #autoImp
done
