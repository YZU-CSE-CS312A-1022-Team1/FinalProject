#!/bin/bash
#Program : Prototype of all users

#clean terminal
clear

#os dependent command usage
if [ `uname` = "FreeBSD" ];then
    ECHO="echo"
else
    ECHO="/bin/echo"
fi

if [ `whoami` == "root" ];then
    NUMOFUSER=`echo -e "${ALLUSER}" | wc -l | awk '{print $1}'`
    ${ECHO} "program will analyze $NUMOFUSER user who has login in this month."
    users=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)
else
    users=`whoami`
    ${ECHO} "You do not have root permission, program will not scan all the user info but only yours."
fi

${ECHO} -e "Analyzing started, it may take a while, please wait "

DIRECTORY="results/users"

if [ ! -w `pwd` ];then
    ${ECHO} -e "Write denied."
    exit
fi

mkdir -p ${DIRECTORY}

PROGRESSCOUNTER=0

for username in $users               #for loop
do

    PROGRESSCOUNTER=$(($PROGRESSCOUNTER +1))
    if [ $(($PROGRESSCOUNTER%10)) == 0 ]; then
      echo -n " $PROGRESSCOUNTER "
    elif [ $(($PROGRESSCOUNTER%10%3)) == 0 ]; then
      echo -n "."
    fi

    USER=$username
    HOME=`eval echo ~${USER}`
    TEMP="${DIRECTORY}/${USER}Data.txt"

    if [ ${HOME}/.bash_history -nt ${HOME}/.history ] && \
       [ ${HOME}/.bash_history -nt ${HOME}/.histfile ] && \
       [ ${HOME}/.bash_history -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.bash_history"`
    elif [ ${HOME}/.history -nt ${HOME}/.bash_history ] && \
         [ ${HOME}/.history -nt ${HOME}/.histfile ] && \
         [ ${HOME}/.history -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.history"`
    elif [ ${HOME}/.histfile -nt ${HOME}/.bash_history ] && \
         [ ${HOME}/.histfile -nt ${HOME}/.history ] && \
         [ ${HOME}/.histfile -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.histfile"`
    else
        LATESTHISTORY=`echo "${HOME}/.sh_history"`
    fi

    if [ -r ${LATESTHISTORY} ];then
        if [ -f ${TEMP} ];then
            rm ${TEMP}
        fi

        SHELL=`finger ${USER} | grep Shell | awk '{print $4}' | \
               awk -F"/" '{print $NF}'`
        NUMOFDIR=`find ${HOME} -type d | wc -l | tr -d ' '`
        NUMOFFLE=`find ${HOME} -type f | wc -l | tr -d ' '`
        LOGINRECORD=`last | grep ${USER} | wc -l | tr -d ' '`
        LASTLOGIN=`last |grep ${USER} | head -n 1 | \
                   awk '{ if (match($2, /^pts/)) { if ($3 != "mosh" && $5 != "mosh") \
                   {print $4, $5, $6, $7 " from " $3} \
                   else{ if ($5 == "mosh"){print $6, $7, $8, $9 " from " $3} \
                   else {print $5, $6, $7, $8" from " $3}}} \
                   else {print $3, $4, $5, $6 " from " $2}}'`
        FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | \
                    sed 's/\M-//g' | sed '/^$/d' | awk '{print $1}'| \
                    sed '/#/d' | sort | uniq -c | sort -n -r | head -n 10`
        if [ `uname` = "FreeBSD" ];then
            PROCESS=`ps -uU ${USER} | awk '{print $2, $3, $4, $7, $8, $10, $11}' | \
                 sed 's/\ /\'$'\t''/g' | sort -g`
        else
            PROCESS=`ps -u ${USER} u | awk '{print $2, $3, $4, $7, $8, $10, $11}' | \
                 sed 's/\ /\'$'\t''/g' | sort -g`
        fi
        DAYOFMONTH=`date +"%d"`
        SPACE="`du -h -d 0 ${HOME} | awk '{print $1}'`B"
        FREQUENCY=`echo $(bc<<<"scale=3;$LOGINRECORD/$DAYOFMONTH" | awk '{printf "%1.3f", $0}')`
        LASTCOMMAND=`wc -l ${LATESTHISTORY} | awk '{print $1}'`

        ${ECHO} -e "\nAnalysis information about user \"${USER}\":
Amount of directories under user's home: \t${NUMOFDIR}
Amount of files under user's home: \t\t${NUMOFFLE}
Default shell of this user: \t\t\t${SHELL}
Last login time: \t\t\t\t${LASTLOGIN}
Login times of this month: \t\t\t${LOGINRECORD}
Login frequency of this month: \t\t\t${FREQUENCY} time(s)/day
Disk space used: \t\t\t\t${SPACE}\n
Most commonly used commands(analyzed by last ${LASTCOMMAND} commands in record):\n${FAVCOMMAND}\n
Currently running process:\n ${PROCESS}" >> $TEMP
    fi
done

${ECHO} -e "Done."
