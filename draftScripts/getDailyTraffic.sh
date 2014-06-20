#!/bin/bash

MONTH=`date +"%m"`
DAYOFMONTH=`date +"%d"`
#date Rx Tx Total (MiB) Avg.rate(kbit/s)
TRAFFIC=`vnstat -d | grep ${MONTH}/ | awk '{if($3 == "KiB"){ print $1" "$2/1024" "$5" "$6" "$8" "$9" "$11} \
         else{print $1" "$2" "$5" "$6" "$8" "$9" "$11}}' | awk '{if($4=="KiB"){print $1" "$2" "$3/1024" "$5" "$6" "$7} \
         else{print $1" "$2" "$3" "$5" "$6" "$7}}' | awk '{if($5=="KiB"){print $1" "$2" "$3" "$4/1024" "$6} \
         else{print $1" "$2" "$3" "$4" "$6}}'`


#choose the the day that has record
DATE=`echo $(echo -e "${TRAFFIC}" | awk 'BEGIN {FS="/"} {print $1"/"$2}')`
RXTX=`echo -e "${TRAFFIC}" | awk '{printf("%6s\t%6s\n",$2, $3)}'`
TOTAL=`echo -e "${TRAFFIC}" | awk '{printf("%6s\n",$4)}'`
RATE=`echo -e "${TRAFFIC}" | awk '{printf("%6s\n",$5)}'`

echo -e ${DATE}
echo "RxTx:"
echo -e "${RXTX}"
echo -e "\nTotal:"
echo -e "${TOTAL}"
echo -e "\nAvg.rate:"
echo -e "${RATE}"
