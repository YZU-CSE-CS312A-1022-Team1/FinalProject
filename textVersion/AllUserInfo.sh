#!/bin/bash

#clean terminal
clear

#os dependent command usage
if [ `uname` = "FreeBSD" ];then
    ECHO="echo"
else
    ECHO="/bin/echo"
fi

${ECHO} -e "Analyzing started, it may take a while, please wait ... "

DIR=results

mkdir -p $DIR && cd $DIR

if [ -f userInformation.txt ];then
    rm userInformation.txt
fi

# Program : rank all user's commands

TOTAL=0    #Count how many commands
TEMP="$(mktemp rankSpaceResult.XXXXXXX)"
TEMPSEC="$(mktemp rankSpaceResult.XXXXXXX)"

if [ `whoami` == "root" ];then
    users=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)
else
    users=`whoami`
fi

for username in $users
do
    USER=$username
    HOME=`eval echo ~${USER}`

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
         FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | \
         sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' | \
         awk '{print $1}'| sed '/#/d' | sort `
         echo -e "\n${FAVCOMMAND}" >> $TEMP    #write file
         COUNT="`wc -l ${LATESTHISTORY} | awk '{print $1}'`"
         TOTAL=$((${COUNT}+$TOTAL))
    fi
#Rank Space
    if [ -d  ${HOME} ]; then  #判斷Path是否存在
        SPACES=`du -s ${HOME}`
        ${ECHO} -e "${SPACES} $username\n" >> $TEMPSEC
    fi

done

#RANK COMMAND
RANK=`awk '{print $1}' $TEMP | sort | uniq -c | sort -n -r | head -n 20`
rm $TEMP

#Rank login times
RANKLOGIN=`last | awk '{if(($1 != "\0")&&($1 != "wtmp")&&($1 != "boot")&& \
           ($1 != "shutdown")&&($1 != "reboot")) print $1}' | \
           sort | uniq -c | sort -n -r | awk '{printf ("%3s%10s%5s\n", NR, $2, $1)} ' | head -n 10`

#Rank Space
RANKSPACE=`awk '{if(($3 != NULL)&&($1 != NULL))print $1 "k\t" $3}' $TEMPSEC | \
           sort -n -r | head -n 10 | awk '{printf ("%3s%12s%7s\n", NR, $2, $1)}'`
rm $TEMPSEC

${ECHO} -e "\nTOTAL number of commands : $TOTAL\n
Ranked commands of all users in record:\n${RANK}\n\n
Rank user's login times : \nNo.\tUser\tTimes\n${RANKLOGIN}\n\n
Ranked space of all users : \nNo.\tUser\tSpace\n${RANKSPACE}\n" >> userInformation.txt

${ECHO} -e "\nDone.\n"
