#!/bin/bash
#linux shell 通过命令行的参数处理

function OS_CHANG_MENULST_HELP()
{
	echo "sh para_input.sh -m mode1 -g 200 -r 3000"
}

if [ $# -lt 6 ];then
	OS_CHANG_MENULST_HELP
	exit 1
fi


while getopts g:r:m: options
do 
    case "$options" in
			
        m)G_TITLE="$OPTARG"
        ;;
        
        g)G_GAP="$OPTARG"
        ;;
        
        r)G_RATIO="$OPTARG"
        ;;
        
        *)
        OS_CHANG_MENULST_HELP
        exit 1
        ;;	
    esac         	
done