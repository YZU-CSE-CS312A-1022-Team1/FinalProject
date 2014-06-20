#!/bin/bash
# Program : rank all user's commands

TOTAL=0    #Count how many commands

TEMP="$(mktemp RankSpaceResult.XXXXXXX)"
users=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)    #username
for username in $users
do
    USER=$username
    HOME=`eval echo ~${USER}`

    if [ ${HOME}/.bash_history -nt ${HOME}/.history ] && [ ${HOME}/.bash_history -nt ${HOME}/.histfile ] && \
       [ ${HOME}/.bash_history -nt ${HOME}/.sh_history ]; then
       LATESTHISTORY=`echo "${HOME}/.bash_history"`
    elif [ ${HOME}/.history -nt ${HOME}/.bash_history ] && [ ${HOME}/.history -nt ${HOME}/.histfile ] && \
         [ ${HOME}/.history -nt ${HOME}/.sh_history ]; then
         LATESTHISTORY=`echo "${HOME}/.history"`
    elif [ ${HOME}/.histfile -nt ${HOME}/.bash_history ] && [ ${HOME}/.histfile -nt ${HOME}/.history ] && \
         [ ${HOME}/.histfile -nt ${HOME}/.sh_history ]; then
         LATESTHISTORY=`echo "${HOME}/.histfile"`
    else
        LATESTHISTORY=`echo "${HOME}/.sh_history"`
    fi
    if [ -r ${LATESTHISTORY} ];then
         FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' | \
         awk '{print $1}'| sed '/#/d' | sort`
         echo -e "\n${FAVCOMMAND}" >> $TEMP    #write file
         COUNT="`wc -l ${LATESTHISTORY} | awk '{print $1}'`"
         TOTAL=$((${COUNT}+$TOTAL))
    fi
done

echo -e "\nTOTAL number of commands : $TOTAL"
RANK=`awk '{print $1}' $TEMP | sort | uniq -c | sort -n -r`
echo -e "Ranked commands of all users in record:\n${RANK}"
rm $TEMP
exit 0

