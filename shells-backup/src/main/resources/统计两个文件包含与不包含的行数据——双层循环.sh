#!/bin/sh


newFile="/home/arthur/temp/temp0817/new_yishoulu.txt"
oldFile="/home/arthur/temp/temp0817/old_yishoulu.txt"

while read oldLine
do
	# echo $oldLine
	
	flag="false"
	while read newLine
	do
		# echo $newLine

		if [ "$oldLine" = "$newLine" ] 
		then
			# echo "$oldLine    $newLine"
			echo "$oldLine" >> "/home/arthur/temp/temp0817/both.txt"
			flag="true"
			break
		fi
	done < $newFile
	

	if [ "$flag" = "false" ]
	then
		# echo $oldLine
		echo "$oldLine" >> "/home/arthur/temp/temp0817/only_old.txt"
	fi
done < $oldFile
