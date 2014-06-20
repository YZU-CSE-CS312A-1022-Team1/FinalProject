#!/bin/bash

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
    LOGINTIME=`last | grep ${USER} |
     awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
     $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}'| sort | uniq -c | \
     awk '$2 == "Mon" {print "1", $2, $1} $2 == "Tue" {print "2", $2, $1} $2 == "Wed" {print "3", $2, $1} \
     $2 == "Thu" {print "4", $2, $1} $2 == "Fri" {print "5", $2, $1} $2 == "Sat" {print "6", $2, $1} \
     $2 == "Sun" {print "7", $2, $1}' | sort -n | awk '{print $2, $3}'`
    ${ECHO} -e "${USER}"
    ${ECHO} -e "${LOGINTIME}\n"
done
