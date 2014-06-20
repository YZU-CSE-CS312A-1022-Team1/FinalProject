#!/bin/bash

#clean terminal
clear

#os dependent command usage
if [ `uname` = "FreeBSD" ];then
    ECHO="echo"
    PS="ps -auU"
else
    ECHO="/bin/echo"
    PS="ps -au"
fi

${ECHO} -e "Analyzing started, it may take a while, please wait ... "

DIR=results
mkdir -p $DIR && cd $DIR

HOSTNAME=`hostname -s`
USERLOGIN=`last | awk '{if($8 == "still"){print $1}}' | uniq | wc -l `
SYSTIME=`uptime | awk '{print $2, $3, $4, $5}' | sed 's/,//g'`
SYSNAME=`uname -s`
SYSPLATFORM=`uname -m`
SYSKERNELVERSION=`uname -r`
RUNNINGPROC=`ps -e | wc -l`
DISKUSAGE=`df -h /etc`
MEMORYINFO=`top | head -n 4 | tail -n 1`
SWAPINFO=`top | head -n 5 | tail -n 1`

if [ `uname` == "FreeBSD" ]; then
    FREEBSD_SYSVERSION=`sysctl -a | egrep -i 'hw.model' | awk '{print $2, $3, $4, $5}'`
    FREEBSD_CPU=`sysctl -a | grep 'hw.ncpu'`
    FREEBSD_MODEL=`sysctl -a | grep 'hw.model'`
    FREEBSD_MACHINE=`sysctl -a | grep 'hw.machine'`
    FREEBSD_CPUUSAGE=`vmstat | tail -n 1 | \
                     awk '{print "usr: " $17 "%","   sys: " $18"%", "    idle: " $19"%"}'`
else
    LINUX_SYSVERSION=`lsb_release -d | awk '{print $2, $3, $4, $5}'`
    LINUX_MEMINFO=`top | head -n 4 | tail -n 1 | \
                  awk '{print $1,$2,$4 " total,  "$6" used,  "$8" free,  "$10" buffers"}'`
    LINUX_SWAPINFO=`top | head -n 5 | tail -n 1 | \
                    awk '{print $1" Swap: "$3 " total,  "$5" used,  "$7" free,  "$9" cached"}'`
    CPUINFO=`cat /proc/cpuinfo`
    CPUUSAGE=`top | head -n 3 | tail -n 1 | \
             awk '{print "usr: " $2 "%",  "    sys: " $4 "%", "    idle: " $8 "%"}'`
fi

${ECHO} -e "\nDone.\n"


#Create systemInfo.txt
if [ -f systemInformation.txt ];then
    rm systemInformation.txt
fi

${ECHO} -e "Hostname: ${HOSTNAME}
Number of users who still logged in:\t${USERLOGIN}
System uptime:\t${SYSTIME}
System Name:\t${SYSNAME}" >> systemInformation.txt

if [ `uname` = "Linux" ];then
    ${ECHO} -e "System version: ${LINUX_SYSVERSION}
System platform: ${SYSPLATFORM}
System kernel version: ${SYSKERNELVERSION}
Number of running process: ${RUNNINGPROC}\n
CPU info:\n${CPUINFO}\n
CPU usage:\n${CPUUSAGE}\n
Overall file system of disk usage:\n${DISKUSAGE}\n
Memory information:\n${LINUX_MEMINFO}\n
Swap usage:\n${LINUX_SWAPINFO} \n " >> systemInformation.txt

elif [ `uname` = "FreeBSD" ];then
    ${ECHO} -e "System version: ${FREEBSD_SYSVERSION}
System platform: ${SYSPLATFORM}
System kernel version: ${SYSKERNELVERSION}
Number of running process:\t${RUNNINGPROC}\n
CPU info:\n${FREEBSD_CPU}\n${FREEBSD_MODEL}\n${FREEBSD_MACHINE}\n
CPU usage:\n${FREEBSD_CPUUSAGE}\n
Overall file system of disk usage:\n${DISKUSAGE}\n
Memory information:\n${MEMORYINFO}\n
Swap usage:\n${SWAPINFO}\n" >> systemInformation.txt

else
    ${ECHO} -e "System version: ${SYSKERNELVERSION}
System platform: ${SYSPLATFORM}
System kernel version: ${SYSKERNELVERSION}
Number of running process:\t${RUNNINGPROC}\n
CPU info:\n${CPUINFO}\n
CPU usage:\n${CPUUSAGE}\n
Overall file system of disk usage:\n${DISKUSAGE}\n
Memory information:\n${MEMORYINFO}\n
Swap usage:\n${SWAPINFO}\n" >> systemInformation.txt

fi