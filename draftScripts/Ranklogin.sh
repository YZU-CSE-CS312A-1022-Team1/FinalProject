#!/bin/bash
# Program:login_time_count/month

RANKLOGIN=`last | awk '{if(($1 != "\0")&&($1 != "wtmp")&&($1 != "boot")&&($1 != "shutdown")&&($1 != "reboot"))print $1}' |\
           sort | uniq -c | sort -n -r | awk '{print NR, $2, $1}'`
echo -e "Rank user's login times : \n${RANKLOGIN}"
exit 0
