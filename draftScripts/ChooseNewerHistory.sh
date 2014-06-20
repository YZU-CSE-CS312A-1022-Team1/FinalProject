#!/bin/bash

USER=$USER
HOME=`eval echo ~${USER}`

if [ ${HOME}/.bash_history -nt ${HOME}/.history ] && [ ${HOME}/.bash_history -nt ${HOME}/.histfile ] && [ ${HOME}/.bash_history -nt ${HOME}/.sh_history ]; then
    LATESTHISTORY=`echo "${HOME}/.bash_history"`
elif [ ${HOME}/.history -nt ${HOME}/.bash_history ] && [ ${HOME}/.history -nt ${HOME}/.histfile ] && [ ${HOME}/.history -nt ${HOME}/.sh_history ]; then
    LATESTHISTORY=`echo "${HOME}/.history"`
elif [ ${HOME}/.histfile -nt ${HOME}/.bash_history ] && [ ${HOME}/.histfile -nt ${HOME}/.history ] && [ ${HOME}/.histfile -nt ${HOME}/.sh_history ]; then
    LATESTHISTORY=`echo "${HOME}/.histfile"`
else
    LATESTHISTORY=`echo "${HOME}/.sh_history"`
fi

FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' | awk '{print $1}'| sed '/#/d' | sort | uniq -c | sort -r | head -n 10`

#echo -e "\n${LATESTHISTORY}\n"
echo -e "Most commonly used commands(analyzed by last `wc -l ${LATESTHISTORY} | awk '{print $1}'` commands in record):\n${FAVCOMMAND}"


