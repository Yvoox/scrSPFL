#!/bin/bash

dbName=$1
dbCollection=$2
path=$3
parse=$4




if [ "$parse" = "parse" ];
then
  ./jsonParser.sh $path
fi

./jsonImport.sh $path $dbName $dbCollection
