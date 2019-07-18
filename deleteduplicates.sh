#!/bin/bash
#This script deletes files with same name, doesn't check if files have same content
#(look into md5 or diff for this functionality)

echo
echo "please wait, deleting files..."

dirname=""
dirname=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
dlt="0"

while read fileName
do

cnt=`find $dirname -type f | grep "$fileName" | wc -l`
cnt=$((--cnt))

while read line
do
dlt=$((++dlt))
rm $line
done < <(find $dirname -type f | grep -m${cnt} "$fileName")

done < <(find $dirname -type f | sed 's_.*/__' | sort | uniq -d)

echo
echo total files deleted: ${dlt}
echo
