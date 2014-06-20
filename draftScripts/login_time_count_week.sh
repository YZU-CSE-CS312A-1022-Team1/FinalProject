#!/bin/bash
#Program:login_time_count/month

LOGINTIME=`last | awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
           $4=="via" {if($5 == "mosh") print $    6} NF==10 {print $4}'| sort | uniq -c | \
           awk '$2 == "Mon" {print "1", $2, $1} $2 == "Tue" {print "2", $2, $1} $2 == "Wed" {print "3", $2, $1} \
           $2 == "Thu" {print "4", $2, $1} $2 == "Fri" {print "5", $2, $1} $2 == "Sat" {print "6", $2, $1} \
           $2 == "Sun" {print "7", $2, $1}' | sort -n | awk '{print $2, $3}'`

echo -e "day number"
echo -e "${LOGINTIME}"
exit 0
