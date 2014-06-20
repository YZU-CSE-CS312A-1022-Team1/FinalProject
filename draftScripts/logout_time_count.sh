#!/bin/bash
# Program:logout_time_count/month

LOGOUTTIME=`last |\
            awk '$3=="mosh" {if(($1 != "wtmp")&&($1 != "reboot")&&($1 != "boot")&&($1 != "shutdown")&&($1 != NULL)&&(($9 != "logged")||($9 != "down")))\
            print $10, $1, $6, $7}\
            $4=="vi" {if(($1 != "wtmp")&&($1 != "reboot")&&($1 != "boot")&&($1 != "shutdown")&&($1 != NULL)&&(($9 != "logged")||($9 != "down")))\
            print $10, $1, $6, $7}\
            $4=="via" {if((($1 != "wtmp")&&($1 != "reboot")&&($5 != "mosh"))&&($1 != "boot")&&($1 != "shutdown")&&($1 != NULL)\
            &&(($9 != "logged")||($9 != "down"))) print $10, $1, $6, $7}\
            $4=="via" {if((($1 != "wtmp")&&($1 != "reboot")&&($5 == "mosh"))&&($1 != "boot")&&($1 != "shutdown")&&($1 != NULL)\
            &&(($9 != "logged")||($9 != "down"))) print $11, $1, $8, $9}\
            {if(($1 != "wtmp")&&($1 != "reboot")&&($3 != "mosh")&&($1 != "boot")&&($1 != "shutdown")&&($1 != NULL)&&($4 != "vi")&&($4 != "via")\
            &&($9 != "logged")&&($9 != "down")) print $9, $1, $5, $6}' |\
            awk -F ":" '$1 < 24 {print $1, $2}'| awk '{if(($1 >= 0)&&($1 <= 24))print $1, "\t"$3, "\t"$4, $5}' | sort`

echo -e "hour\tuser\t\tdate"
echo -e "\n${LOGOUTTIME}"
exit 0
