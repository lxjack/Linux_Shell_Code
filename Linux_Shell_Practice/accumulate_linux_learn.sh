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



二、sed使用   插入---（行前行后插入）---删除---（按行删除）---显示---（按行显示）---替换---（按行替换 匹配内容替换）   done
1.插入新行(i a)
1.1在指定行的前一行插入新行
root@/home/jack/workspace #sed -i '3i name=$1' au.sh 

1.2在指定行的后一行插入新行
root@/home/jack/workspace #sed -i '1a name=$1' au.sh


2.删除指定行(d)
2.1指定行号进行删除
root@/home/jack/workspace #sed -i '3d' au.sh
root@/home/jack/workspace #grep -n  '.*' au.sh | sed '2,$d'
1:#!/bin/bash

2.2匹配删除对应的行
root@/home/jack/workspace #sed -i '/name=/d' au.sh


3.显示指定行(p)
命令格式:sed -n 'num1,num2p' 文件
3.1列出文件/etc/passwd的5至7行
[root@localhost ~]# nl /etc/passwd | sed -n '5,7p'
     5	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
	 
3.2列出文件的最后一行
[root@localhost ~]# sed -n '$p' /etc/passwd
jack:x:500:500:jack_PC:/home/jack:/bin/bash

3.3列出文件的最后两行
[root@localhost ~]# sed -n '30,$p' /etc/passwd
tcpdump:x:72:72::/:/sbin/nologin
jack:x:500:500:jack_PC:/home/jack:/bin/bash


4.替换(c   s)
行替换(c)
4.1指定行号进行行替换
root@/home/jack/workspace #sed -i '3c name=$3' au.sh 
4.2匹配内容进行行替换
root@/home/jack/workspace #sed -i '/name=/c name=$1' au.sh

部分数据查找替换(s)
命令格式:sed 's/要被替换的被查找字符串/新字符串/g' 文件
4.3查找替换（除了替换为空外，还可以替换为其它字符）
root@/home/jack/workspace #ifconfig eth0 | grep "Bcast"
          inet addr:192.168.225.129  Bcast:192.168.225.255  Mask:255.255.255.0
root@/home/jack/workspace #ifconfig eth0 | grep "Bcast" | sed 's/^.*addr://g' | sed 's/[ \t]*Bcast.*//g'
192.168.225.129


5.获取匹配行行号
命令格式:sed -n '/要被替换的被查找字符串/='  文件
[root@localhost ~]# sed -n '/root/=' /etc/passwd
1

获取最后一行的行号
root@/home/jack/workspace #sed -n '$=' au.sh 
12
root@/home/jack/workspace #cat au.sh | wc -l
12



三、awk使用（awk处理流程  字段分隔符指定 条件  动作）
awk '条件类型1 {动作1} 条件类型2 {动作2}'  filename

1.awk处理流程：
1.1.读入一行，并将这行数据填入$0,$1,$2,$3变量当中；
1.2.根据条件判断这行是否需要进行后面动作；
1.3.继续处理后面的行.


2.指定字段分隔符：
awk -F "|" 

[root:/home/workspace]#info="10001|CoyoteInc.|200MapleLane|Detroit|MI|44444|USA|YLee|ylee@coyote.com"
[root:/home/workspace]#echo $info | awk -F "|" '{print $1,"\t",$NF}'
10001    ylee@coyote.com
[root:/home/workspace]#


3.条件：
3.1.值大小判断
>,>=,<,<=,==,!=
[root:/home/workspace]#awk -F: '$3<=10 {print $0}' passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin


3.2.正则匹配
3.2.1.一行之中匹配
[root:/home/workspace]#cat -n passwd | awk '/root/ {print $0}'
     1  root:x:0:0:root:/root:/bin/bash
    10  operator:x:11:0:operator:/root:/sbin/nologin
    44  roo:x:1000:1000:root:/home/roo:/bin/bash
[root:/home/workspace]#

3.2.2.行内的匹配与不匹配
[root:/home/workspace]#awk '!/nologin$/ {print $0}' passwd | wc -l
5
[root:/home/workspace]#awk '/nologin$/ {print $0}' passwd | wc -l
39

3.2.3.指定字段匹配
~：左侧的字段是否被模式匹配
[root:/home/workspace]#awk -F: '($1~/root/)&&($NF~/bash/) {print $0}' /etc/passwd
root:x:0:0:root:/root:/bin/bash

!~：左侧的字段是否不能被模式匹配
[root:/home/workspace]#awk -F: '($1!~/root/)&&($NF~/bash/) {print $0}' /etc/passwd
roo:x:1000:1000:root:/home/roo:/bin/bash
[root:/home/workspace]#


3.2.4.逻辑操作符：
&&：与
[root:/home/workspace]#cat -n passwd | awk 'NR<=10&&NR>=5 {print $0}'
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6  sync:x:5:0:sync:/sbin:/bin/sync
     7  shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8  halt:x:7:0:halt:/sbin:/sbin/halt
     9  mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10  operator:x:11:0:operator:/root:/sbin/nologin
[root:/home/workspace]#


||：或
[root:/home/workspace]#cat -n passwd | awk 'NR<=3||NR>=42 {print $0}'
     1  root:x:0:0:root:/root:/bin/bash
     2  bin:x:1:1:bin:/bin:/sbin/nologin
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
    42  tcpdump:x:72:72::/:/sbin/nologin
    43  avahi:x:70:70:Avahi mDNS/DNS-SD Stack:/var/run/avahi-daemon:/sbin/nologin
    44  roo:x:1000:1000:root:/home/roo:/bin/bash
[root:/home/workspace]#


!：非
[root:/home/workspace]#cat -n passwd | awk '!(NR>=3) {print $0}'
     1  root:x:0:0:root:/root:/bin/bash
     2  bin:x:1:1:bin:/bin:/sbin/nologin
[root:/home/workspace]#



4.动作
print
输出格式：print item1,item2 ...
备注：使用逗号作为分隔符；输出item可以是字符串、內建变量、awk表达式；若省略item，则显示$0整行；

printf
格式化输出：printf FORMAT, item1, item2...按位放在format中。
注意事项：format必须要给出；如需换行，必须要显示写出；format中需要为后面每个item指定格式符；

格式符：
%c：显示字符的ASCII值
%d：显示十进制整数
%e：科学计数法数值显示
%f：显示为浮点数
%g：以科学计数法显示浮点数
%s：显示字符串
%u：显示无符号整数
%%：显示%自身

控制语句if：
if(condition){statement}
if(condition){statement} else {statements}

[root:/home/workspace]#awk -F ":" '{if ($NF~/bash$/) {$1=0;print $1,"\t",$NF} else {$1=1;print $1,"\t",$NF}}' passwd
0        /bin/bash
1        /sbin/nologin
1        /sbin/nologin
0        /bin/bash

BEGIN/END模式：BEGIN{}表示仅在开始处理文件中的文本之前执行一次的程序，例如打印表头。END{}表示文本处理完成之后执行一次，例如汇总数据。
[root:/home/workspace]#awk -F: 'BEGIN{i=0;j=0};{if ($NF~/nologin$/){i++}else{j++}}; END{print i, j}' passwd
39 5
[root:/home/workspace]#
[root:/home/workspace]#awk -F: 'BEGIN{i=1;j=1};{if ($NF~/nologin$/){i++}else{j++}}; END{print i, j}' passwd
40 6
[root:/home/workspace]#

参考：https://www.cnblogs.com/zimskyzeng/p/11630071.html



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


五、正则表达式(todo)
通过一些特殊的字符以及搭载着量词，进行字符串的模式匹配工作。
