#!/bin/bash
set -e
set -u
set -o pipefail
if test -f filenames.txt
then
    rm filenames.txt
fi
ls ./zips/ > filenames.txt
cat filenames.txt
echo "Enter filenames.txt"
read file
while IFS= read -r line
do
    if test "!" -d ./unzips
    then
        mkdir ./unzips
    else
        echo "unzips exists"
    fi    
    if test "!" -d ./ToUpload
    then
	mkdir ./ToUpload
    else
	echo "ToUpload exists"
    fi
    echo $line
    #curl http://vnhm.de/_MHH/php/CTStackDownload.php?ID=$line > ./zips/Stack$line.zip
    unzip -q ./zips/$line -d ./unzips/
    if test -f ./unzips/Info.txt
    then
        dos2unix ./unzips/Info.txt
        Sorce=$(awk '/^Sorce: / {print $2}' ./unzips/Info.txt) 
        CatNum=$(awk '/^SorceID:/ {print $3}' ./unzips/Info.txt)
        Source=${Sorce%$'\r'}
        Number=${CatNum%$'\r'}	
        echo $Source
        echo $Number
    else
        echo "Info.txt not found"
    fi
    if [[ $Sorce == "UWFC" ]]
    then
        Museum="Uwfc"
        Collection="A"
        echo $Museum
        echo $Collection
    else
        echo "Not UWFC"
    fi
    name="${Museum}-${Collection}-${Number}_body"
    jpgname="${name}_"
    mv ./unzips/*.log ./ToUpload/"${name}.log"
    unzip -q ./unzips/Stack.zip -d ./unzips/"${name}"
    for f in ./unzips/"${name}"/*.jpg ; do mv $f ${f//Image/$jpgname} ; done
    zip -q -r ./unzips/"${name}.zip" ./unzips/"${name}" 
    mv ./unzips/"${name}.zip" ToUpload/
    #curl http://vnhm.de/_MHH/php/CTSurfaceDownload.php?ID=$line&Scan=CT&threshold=77 > ./zips/Surface$line.zip
    #unzip -q ./zips/Surface$line.zip -d ./unzips/
    #mv ./unzips/*.stl ./ToUpload/"${name}.stl"
    rm -r unzips/
    rm ./zips/$line
done < $file
ls ToUpload/
