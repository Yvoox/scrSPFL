#!/bin/bash

jsonPath=$1


for filename in $jsonPath/*.json; do
  echo $filename 'in processing..'

  fileContent="$( cat $filename )"
  fileContent=$(sed 's/{/{\\n/g' <<< $fileContent)
  fileContent=$(sed 's/}/}\\n/g' <<< $fileContent)
  fileContent=$(sed 's/,/,\\n/g' <<< $fileContent)
  fileContent=$(sed 's/\[/\[\\n/g' <<< $fileContent)
  fileContent=$(sed 's/\]/\]\\n/g' <<< $fileContent)



  echo -e ${fileContent} > $filename







done
