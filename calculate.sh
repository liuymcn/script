#!/bin/bash

# This shell is aim to caculate the mount  of log base on key word
# This shell is limit
# welcome to improve it

# created by Lucas 2018-07-14

calculate() {

  affiliateId=$1

  total=`sh find.sh findByHourInterval aff_click txt w 24 1 '\"in_affiliate_id\":'$affiliateId',' '\"click_source\":2' | wc -l`
  fail=`sh find.sh findByHourInterval aff_click txt w 24 1 '\"in_affiliate_id\":'$affiliateId',' '\"click_source\":2' '\"affiliate_id\":2411' | wc -l`

  # echo "affiliateId: "$affiliateId" mountOfFail: "$fail" ,mountOfSuccess: "$total
  # echo $affiliateId" , "$fail" , "$total

  # calculate the rate
  if [ $total -gt 0 ];
  then
    rate=$(echo "scale=4; $fail/$total*100" | bc)
  else
    rate=0
  fi

  printf "%s , %s , %s , %4.2f %%\n" $affiliateId $fail $total $rate

}

for affiliateId in $@
do
  calculate $affiliateId
done
