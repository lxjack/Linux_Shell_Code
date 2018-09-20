linux  学习总结

一.shell script编程:
1.数值计算
var=$((计算内容))
ex:
[root@/home/jack/workspace]$num=$((1+2*3));echo $num
7

2.判定式
2.1文件相关判定
-e	判断目录或者文件是否存在
[root@/home/jack/workspace]$test -e /home/jack/workspace;echo $?
0
[root@/home/jack/workspace]$test -e /home/jack/workspace1;echo $?
1
[root@/home/jack/workspace]$test -e /home/jack/workspace/cron.txt;echo $?
0
[root@/home/jack/workspace]$test -e /home/jack/workspace/cron.txt1;echo $?
1

-f  判断文件是否存在
[root@/home/jack/workspace]$test -f /home/jack/workspace/;echo $?
1
[root@/home/jack/workspace]$test -f /home/jack/workspace/cron.txt;echo $?
0

-d  判断目录是否存在
[root@/home/jack/workspace]$test -d /home/jack/workspace/cron.txt;echo $?
1
[root@/home/jack/workspace]$test -d /home/jack/workspace/;echo $?
0

2.2整数之间判定
-eq		两个数值相等
-ne		两个数值不等
-gt		大于
-ge		大于等于
-lt		小于
-le		小于等于

2.3字符串判定
-n		字符串不为空
-z		字符串为空
==		两个字符串相等
!=		两个字符串不相等

2.4条件连接符1
-a		取并
-o		取或
!		取反
[root@/home/jack/workspace]$test -d /home/jack/workspace/ -a -f /home/jack/workspace/grub.conf;echo $?
0
[root@/home/jack/workspace]$test ! -d /home/jack/workspace1/ -a -f /home/jack/workspace/grub.conf;echo $?
0

2.5条件连接2
&&		取并
||		取或
[root@/home/jack/workspace]$if [ 1 -eq 1 ] && [ "root" == "root" ];then  echo yes; fi
yes
[root@/home/jack/workspace]$if [ 1 -ne 1 ] || [ "root" == "root" ];then  echo yes; fi
yes


3.逻辑判断  
3.1if语句
name=$1
if [ "$name" == "root" ];then
	echo "authority is super admin"
elif [ "$name" == "jack" ];then
	echo "authority is admin"
elif [ "$name" == "jane" ];then
	echo "authority is guest"
else
	echo "authority is others"
fi

3.2case语句 模式匹配
详见/etc/init.d/atd


4.循环语句
4.1while 循环
$i=0
sum=0
while [ $i -lt 101 ] 
do 
	sum=$(($i+$sum)) 
	i=$(($i+1))
done
echo $sum
5050

4.2for  循环 数值处理
sum=0
for((i=0;i<=100;i++))
do
	sum=$(($sum+$i))
done
$echo $sum
5050

4.3for  循环  
for i in `ls /home/jack/workspace/`
do 
	echo "$i"
done

4.4在循环中也可使用break和contine
break			跳出本层循环
continue		跳过本次循环


5.函数定义
function mywork()
{
	函数体
}


二、正则表达式









三、sed和awk使用










