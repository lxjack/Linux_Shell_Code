#!/bin/bash
#while loop,compute 1+2+...+100=?

i=1
sum=0

while [ $i -le 100 ]
do
	sum=$(($sum+$i))
	i=$(($i+1))
done

echo $sum
