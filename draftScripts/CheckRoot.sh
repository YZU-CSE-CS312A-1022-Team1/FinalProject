#!/bin/bash
CHECK=`sudo whoami`
if [ ${CHECK} == "root" ];then
    echo "root"
else
    echo -e "\nPermit denied"
fi
exit 0
