#!/bin/bash
#Program:login_time_count/month

LOGINTIME=`last | awk '$3=="mosh" {print $8} $4=="vi" {print $8} $4=="via" {if($5 != "mosh") print $8} \
           $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}' | awk -F ":" '{print $1}' | \
           sort | uniq -c | awk '{print $2 "\t" $1}'`

echo -e "time number"
echo -e "${LOGINTIME}"
exit 0
