#!/bin/sh

## match and extract urls and titles by docids from full product data file
## added by arthur.liu on 2017-06-21

here=`pwd`
cd $here

source_data_file=$here"/source_data_file.json"
temp_data_file=$here"/temp_data_file.txt"
source_docids_file=$here"/source_docids_file.txt"
target_docids_urls_titles_file=$here"/target_docids_urls_titles_file.txt"

cat $source_data_file | grep "DOCID" | awk '{FS="DOCID\":\"|\",\"Site|url\":\"|\",\"discovery|Title\":{\"en\":\"|\",\"cn"} {print $2" "$4" "$6}' > $temp_data_file

cat $source_docids_file | while read docId
do
	# echo $docId
	grepResult=`grep "$docId" $temp_data_file`
	# echo $grepResult
	
	if [ "$grepResult" = "" ]
	then
		echo "$docId" >> $target_docids_urls_titles_file
	else
		echo "$grepResult" >> $target_docids_urls_titles_file
	fi
done





