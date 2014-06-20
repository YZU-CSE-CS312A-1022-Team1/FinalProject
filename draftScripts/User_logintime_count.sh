#!/bin/bash
#User login time count
#os dependent command usage
if [ `uname` = "FreeBSD" ];then
    ECHO="echo"
    PS="ps -auU"
else
    ECHO="/bin/echo"
    PS="ps -au"
fi
ALLUSER=`echo $(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)`   #username

for username in $ALLUSER               #for loop
do
    USER=$username
    LOGINTIME=`last | grep ${USER} | awk '$3=="mosh" {print $8} $4=="vi" {print $8} \
               $4=="via" {if($5 != "mosh") print $8} $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}'| \
               awk -F ":" '{print $1}' | sort | uniq -c | awk '{print $2 "\t\t" $1}'`

    ${ECHO} -e "${USER}"
    ${ECHO} -e "Login hour  times"
    ${ECHO} -e "${LOGINTIME}\n"
done
