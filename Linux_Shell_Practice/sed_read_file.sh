#!/bin/bash
#use sed read the file while.sh

num=`cat ./while.sh | wc -l`

for ((i=1 ; i<=${num} ; i=i+1))
do
	temp=$(sed -n ""$i","$i"p" ./while.sh)


	if [ -z "$temp" ];then
		
		continue

	fi

	echo $temp

done

