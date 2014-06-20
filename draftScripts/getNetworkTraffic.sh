#!/bin/bash

TRAFFIC_TODAY=`vnstat --oneline | awk  'BEGIN {FS=";"} {printf("today\t\t%11s\t%11s\t%11s\t\n", $4, $5, $6) }'`
TRAFFIC_MONTH=`vnstat --oneline | awk  'BEGIN {FS=";"} {printf("%7s\t\t%11s\t%11s\t%11s\t\n", $8, $9, $10, $11) }'`

echo -e "\t\t\trx\t\ttx\t\ttotal"
echo -e "\t${TRAFFIC_TODAY}"
echo -e "\t${TRAFFIC_MONTH}"

