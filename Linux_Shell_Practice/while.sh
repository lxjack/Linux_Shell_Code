#!/bin/bash

i=1
sum=0

while [ $i -lt 101 ]
do
	sum=$(($sum+$i))
	i=$(($i+1))
done

echo $sum


