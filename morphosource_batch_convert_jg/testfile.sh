read file
while IFS= read -r line
do
    echo $line
done < ./filenames.txt
