#!/bin/bash
#Program:login_time_count/month

LOGINTIME=`last | \
           awk '$3=="mosh" {if(($1 != "wtmp")&&($1 != "reboot")&&($1 != "boot")&&($1 != "shutdown")) print $8, $1, $6, $7} \
           $4=="vi" {if(($1 != "wtmp")&&($1 != "reboot")&&($1 != "boot")&&($1 != "shutdown")) print $8, $1, $6, $7} \
           $4=="via" {if(($1 != "wtmp")&&($1 != "reboot")&&($1 != "boot")&&($1 != "shutdown")&&($5 != "mosh")) print $8, $1, $6, $7} \
           $4=="via" {if(($1 != "wtmp")&&($1 != "reboot")&&($5 == "mosh")&&($1 != "boot")&&($1 != "shutdown")) print $9, $1, $7, $8} \
           {if(($1 != "wtmp")&&($1 != "reboot")&&($3 != "mosh")&&($4 != "vi")&&($4 != "via")&&($1 != "boot")&&($1 != "shutdown")) \
           print $7, $1, $5, $6}' | \
           awk -F ":" '$1 < 24 {print $1, $2}' | awk '{if(($1 >= 0)&&($1 <= 24))print $1, "\t"$3, "\t"$4, $5}' | sort`

echo -e "hour\tuser\t\tdate"
echo -e "\n${LOGINTIME}"
exit 0
