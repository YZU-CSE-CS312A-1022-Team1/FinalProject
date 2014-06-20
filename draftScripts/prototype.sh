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

USER=$USER
HOME=`eval echo ~${USER}`
SHELL=`finger ${USER} | grep Shell | awk '{print $4}' | awk -F"/" '{print $NF}'`
NUMOFDIR=`find ${HOME} -type d | wc -l | tr -d ' '`
NUMOFFLE=`find ${HOME} -type f | wc -l | tr -d ' '`
LOGINRECORD=`last | grep ${USER} | wc -l | tr -d ' '`
LASTLOGIN=`last ${USER} | head -n 1 | awk '{ if (match($2, /^pts/)) { if ($3 != "mosh" && $5 != "mosh") {print $4, $5, $6, $7 " from " $3} else{ if ($5 == "mosh"){print $6, $7, $8, $9 " from " $3} else {print $5, $6, $7, $8" from " $3}}} else {print $3, $4, $5, $6 " from " $2}}'`
FAVCOMMAND=`awk '{print $1}' ${HOME}/.bash_history | sort | uniq -c | sort -r | head -n 10`
PROCESS=`${PS} ${USER} | awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}' | sed 's/\ /\'$'\t''/g' | sort -g`
DAYOFMONTH=`date +"%d"`
SPACE="`du -h -d 0 ${HOME} | awk '{print $1}'`B"

#CENTER=$((COLUMNS /2))
#COLUMNS=`tput cols`
#printf "%*s\n" ${CENTER} "Analysis information about user '${USER}' :"

${ECHO} -e "\nAnalysis information about user '\e[1;36;40m${USER}\e[0m':";
${ECHO} -e "\nAmount of directories under user's home: \t\e[1;36;40m${NUMOFDIR}\e[0m"
${ECHO} -e "Amount of files under user's home: \t\t\e[1;36;40m${NUMOFFLE}\e[0m"
${ECHO} -e "Default shell of this user: \t\t\t\e[1;36;40m${SHELL}\e[0m"
${ECHO} -e "Last login time: \t\t\t\t\e[1;36;40m${LASTLOGIN}\e[0m"
${ECHO} -e "Login times of this month: \t\t\t\e[1;36;40m${LOGINRECORD}\e[0m"
${ECHO} -e "Login frequency of this month: \t\t\t\e[1;36;40m$(bc<<<"scale=3;$LOGINRECORD/$DAYOFMONTH" | awk '{printf "%1.3f", $0}')\e[0m time(s)/day"
${ECHO} -e "Disk space used: \t\t\t\t\e[1;36;40m${SPACE}\e[0m"
${ECHO} -e "Most commonly used commands(analyzed by last `wc -l ${HOME}/.bash_history | awk '{print $1}'` commands in record):\n${FAVCOMMAND}"
${ECHO} -e "Currently running process:\n ${PROCESS}"

${ECHO} -e "\nDone.\n"
