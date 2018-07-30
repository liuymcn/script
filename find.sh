#!/bin/bash

userage(){
  echo -e "Usage:
    命令使用格式：
      1. find 基于日期查找
         文件目录格式
        .
         |-history
           |- logName-date.logType
         |-logName.logType

         命令格式
         sh scriptName find logName logType startDate (开始时间 格式:20180701) endDate (结束时间 格式:20180701) ...searchKey(可变的参数)
         如：sh find.sh find update log 20180701 20180702 123

       2. findByHourInterval 基于小时查找
         文件目录格式
         .
          |-logName-time.logType

         命令格式
         sh scriptName findByHourInterval logName logType direct(w, e, we) interval step ...searchKey(可变的参数)
         如：sh find.sh findByHourInterval update txt w 10 1 123
  "
}

# This shell is aim to retrieve information from many file
# This shell is limit
# welcome to improve it

# modified by Lucas 2018-07-14
# features:
#   1. searchKey use variable parameter
#   2. check whether the file exists

# modify by Lucas 2018-07-26
# features:
#   1. customize file type
#   2. function search base hour but can not customize time


find() {

  logName=$1
  logType=$2
  startDate=$3
  endDate=$4
  searchKey=$5

  shift
  shift
  shift
  shift
  shift

  prefixCommand="grep $searchKey "
  suffixCommand=""


  until [ $# -eq 0 ]; do
    suffixCommand+=" | grep $1"
    shift
  done

  while [ $startDate -le $endDate ]
  do
    filePath="history/$logName-$startDate.log"
    if [ -f $filePath ]; then
  #   echo $prefixCommand $filePath $suffixCommand
      eval $prefixCommand $filePath $suffixCommand
    else
      echo "can not find file -> " $filePath
    fi
    startDate=`date -d"+1 days $startDate" +%Y%m%d`
  done

  # current log
  filePath="$logName.$logType"
  eval $prefixCommand $filePath $suffixCommand

}

findByHourInterval() {
  logName=$1
  logType=$2
  direct=$3
  interval=$4
  step=$5
  searchKey=$6

  shift
  shift
  shift
  shift
  shift

  prefixCommand="grep $searchKey "
  suffixCommand=""


  until [ $# -eq 0 ]; do
    suffixCommand+=" | grep $1"
    shift
  done

  if [ "$direct" = "w" ] || [ "$direct" = "e" ]; then
    for (( i = 0; i < $interval; i = i + $step ))
    do

      if [ $direct = "w" ]; then
        time=`date -d "- $i hour $startDate" +%Y%m%d%H`
      else
        time=`date -d "+ $i hour $startDate" +%Y%m%d%H`
      fi

      if [ $i -eq 0 ];
      then
        filePath="$logName.$logType"
      else
        filePath="$logName-$time.$logType"
      fi


      if [ -f $filePath ]; then
        eval $prefixCommand $filePath $suffixCommand
      else
        echo "can not find file -> " $filePath
      fi
    done

  fi
}

if [ "$1" = "find" ] && [ -n  "$2" ] && [ -n  "$3" ] && [ -n  "$4" ] && [ -n  "$5" ] && [ -n  "$6" ]
then
    shift
    find $@

  # if [ "$1" = "userage" ] || [ "$1" = "help" ]
  # then
  #    userage
  #    exit
  # fi

elif [ "$1" = "findByHourInterval" ] && [ -n  "$2" ] && [ -n  "$3" ] && [ -n  "$4" ] && [ -n  "$5" ]  && [ -n  "$6" ]
then
  shift
  findByHourInterval $@

else
   userage
   exit
fi
