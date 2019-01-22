#!/bin/bash
set -e
set -u
set -o pipefail
echo "Enter Name of text file with VNHM Numbers"
read file
while IFS= read -r line
do
    if test "!" -d ./zips
    then 
        mkdir ./zips
    else
        echo "zips exists"
    fi
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
    unzip -q ./zips/Stack$line.zip -d ./unzips/
    if test -f ./unzips/Info.txt
    then
        dos2unix ./unzips/Info.txt
        Sorce=$(awk '/^Sorce: / {print $2}' ./unzips/Info.txt) 
        CatNum=$(awk '/^SorceID: uw / {print $3}' ./unzips/Info.txt)
        Source=${Sorce%$'\r'}
        Number=${CatNum%$'\r'}	
        echo $Source
        echo $Number
    else
        echo "Info.txt not found"
    fi
    if [[ $Sorce == "Uwfc" ]]
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
    unzip -q ./unzips/Stack.zip -d ./"${name}"
    for f in "${name}"/*.jpg ; do mv $f ${f//Image/$jpgname} ; done
    zip -q -r "${name}.zip" "${name}" 
    mv "${name}.zip" ToUpload/
    #curl http://vnhm.de/_MHH/php/CTSurfaceDownload.php?ID=$line&Scan=CT&threshold=77 > ./zips/Surface$line.zip
    #unzip -q ./zips/Surface$line.zip -d ./unzips/
    #mv ./unzips/*.stl ./ToUpload/"${name}.stl"
    rm -r zips/
    rm -r unzips/
    rm -r "${name}"
done < $file
ls ToUpload/
