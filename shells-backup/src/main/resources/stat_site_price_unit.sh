#!/bin/sh

here=`pwd`
input_file=$here"/55haitao_items_full_data_2017-05-25.json"
output_file=$here"/site_prict_unit_list.result"

echo $here
echo $input_file

`cat $input_file | awk '{FS="url|discovery_time|unit|Stock"} {print $2""$5}' | awk '{FS="://|}"} {print $2}' | awk '{FS="/|:"} {if(length($NF) < 9) print $1" "$NF}' | sort | uniq > $output_file`
