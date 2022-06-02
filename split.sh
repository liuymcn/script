#!/bin/bash

usage(){
echo -e "Usage: 
  命令使用格式：
    sh scriptName spl number（按多少行进行分割）fileName（需要分割的源文件） afterName（分割后的文件前缀）
  如：sh chaifen.sh split 10000 offer_affiliate_cap_conf_ins_1953.sql offer_affiliate_
"
}

#文件拆分函数，根据传入参数进行拆分
spl(){
filelines=$1
fileName=$2
zifile=$3
split -l $1  $2  -d -a 5  $3
for i in $3*
    do mv $i $i.sql
done
}

if [ "$1" = "split" ]&& [ -n  "$2" ]&& [ -n  "$3" ]&& [ -n  "$4" ];
then
    spl $2 $3 $4;
if [ "$1" = "usage" ] || [ "$1" = "help" ];
then
   usage
fi
else
   usage
   exit
fi
