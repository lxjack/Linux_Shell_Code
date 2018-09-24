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



二、sed使用
1.列出文件的指定行数
命令格式:sed -n 'num1,num2p' 文件
1.1列出文件/etc/passwd的5至7行
[root@localhost ~]# nl /etc/passwd | sed -n '5,7p'
     5	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
1.2列出文件的最后一行
[root@localhost ~]# sed -n '$p' /etc/passwd
jack:x:500:500:jack_PC:/home/jack:/bin/bash
1.3列出文件的最后两行
[root@localhost ~]# sed -n '30,$p' /etc/passwd
tcpdump:x:72:72::/:/sbin/nologin
jack:x:500:500:jack_PC:/home/jack:/bin/bash


2.获取匹配行的行号
命令格式:sed -n '/要被替换的被查找字符串/='  文件
[root@localhost ~]# sed -n '/jack/=' /etc/passwd
31
[root@localhost ~]# sed -n '/\/bin\/bash/=' /etc/passwd
1
31
获取最后一行的行号
root@/home/jack/workspace #sed -n '$=' au.sh 
12
root@/home/jack/workspace #cat au.sh | wc -l
12


3.新增一行
3.1在指定行的后面新增一行
root@/home/jack/workspace #sed -i '1a name=$1' au.sh

3.2在指定行的前面新增一行
root@/home/jack/workspace #sed -i '3i name=$1' au.sh 


4.按行进行删除文本
4.1指定行号进行删除
root@/home/jack/workspace #sed -i '3d' au.sh
root@/home/jack/workspace #grep -n  '.*' au.sh | sed '2,$d'
1:#!/bin/bash

4.2匹配删除对应的行
root@/home/jack/workspace #sed -i '/name=/d' au.sh


5.行替换
5.1指定行号进行行替换
root@/home/jack/workspace #sed -i '3c name=$3' au.sh 

5.2匹配内容进行行替换
root@/home/jack/workspace #sed -i '/name=/c name=$1' au.sh


6.部分数据的查找替换
命令格式:sed 's/要被替换的被查找字符串/新字符串/g' 文件
6.1查找替换（除了替换为空外，还可以替换为其它字符）
root@/home/jack/workspace #ifconfig eth0 | grep "Bcast"
          inet addr:192.168.225.129  Bcast:192.168.225.255  Mask:255.255.255.0
root@/home/jack/workspace #ifconfig eth0 | grep "Bcast" | sed 's/^.*addr://g' | sed 's/[:blank:]*Bcast.*//g'
192.168.225.129

6.2将注释行替换为空
root@/home/jack/workspace #head -1 para_input.sh | sed 's/#.*//g'

root@/home/jack/workspace #



三、awk使用（字段分割处理工具）
1.获取root用户的最新登陆时间
root@/home/jack/workspace #who -m | grep root | awk '{print $1 "  " $3 " " $4}'
root  2018-09-23 05:21
2.获取主机IP,制定awk分隔符
root@/home/jack/workspace #ifconfig eth0 | grep "inet addr" | awk '{print $2}' | awk -F ":" '{print $NF}'
192.168.224.111



四、定时任务
1.at	单次任务
at -l 					查询所有任务
at -d [任务流水号]		删除对应流水号的任务
at -c [任务流水号]		查看对应流水号任务的详情

指定任务
root@/home/jack/workspace #at now + 20minutes
at> shutdown -h now
at> <EOT>

root@/var/spool/at #date "+%H:%M %Y-%m-%d"
06:09 2018-09-23
root@/var/spool/at #at 06:09 2018-09-24
at> shutdown -h now
at> <EOT>
job 5 at 2018-09-24 06:09

2.crontab	循环任务
分		时		日		月		周					command
0-59	0-23	1-31	1-12	0-7(07均指周末)

时间指代特殊字符
*	代表任意时刻都接受
,	代表分割时段
-	代表一段时间范围
/n	每隔n单位时间间隔

ex: */20	 2,4,6	 15-20	 *   *  sh collect_message.sh		每个月的15至20日的2、4、6时，每隔20分钟手机一下日志

crontab -e		编辑循环任务
crontab	-l		查看定时任务
crontab	-r		删除所有定时任务（不推荐使用  可以使用crontab -e进行编辑修改）



五、正则表达式
通过一些特殊的字符以及搭载着量词，进行字符串的模式匹配工作。
