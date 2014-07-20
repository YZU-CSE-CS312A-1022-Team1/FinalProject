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


if [ `whoami` == "root" ];then
    users=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)
  else
    users=`whoami`
    ${ECHO} "You do not have root permission, program will only list login ranking and login time distribution."
fi

#Rank login times
RANKLOGIN=`last | awk '{if(($1 != "\0")&&($1 != "wtmp")&&($1 != "boot")&& \
           ($1 != "shutdown")&&($1 != "reboot")) print $1}' | \
           sort | uniq -c | sort -n -r | awk '{printf ("%3s%10s%5s\n", NR, $2, $1)} ' | head -n 10`
WEEKLOGIN=($(last | awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
          $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}' | sort | uniq -c | \
          awk '$2 == "Mon" {print "1", $2, $1} $2 == "Tue" {print "2", $2, $1} $2 == "Wed" {print "3", $2, $1} \
          $2 == "Thu" {print "4", $2, $1} $2 == "Fri" {print "5", $2, $1} $2 == "Sat" {print "6", $2, $1} \
          $2 == "Sun" {print "7", $2, $1}' | sort -n | awk '{print $2, $3}'))
WEEKDAY="Mon Tue Wed Thu Fri Sat Sun"
WEEKLOGINTIMESLIST=(0 0 0 0 0 0 0)
for (( i = 0; i<${#WEEKLOGIN[@]};i++)); do
  if [ ${WEEKLOGIN[i]} == "Mon" ]; then
    WEEKLOGINTIMESLIST[0]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Tue" ]; then
    WEEKLOGINTIMESLIST[1]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Wed" ]; then
    WEEKLOGINTIMESLIST[2]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Thu" ]; then
    WEEKLOGINTIMESLIST[3]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Fri" ]; then
    WEEKLOGINTIMESLIST[4]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Sat" ]; then
    WEEKLOGINTIMESLIST[5]=${WEEKLOGIN[$(($i+1))]}
  elif [ ${WEEKLOGIN[i]} == "Sun" ]; then
    WEEKLOGINTIMESLIST[6]=${WEEKLOGIN[$(($i+1))]}
  fi
done
for (( j = 0; j<${#WEEKLOGINTIMESLIST[@]};j++)); do
  WEEKLOGINSTRING="$WEEKLOGINSTRING${WEEKLOGINTIMESLIST[j]} "
done
WLOGINDAY=`echo ${WEEKDAY} | \
           awk '{printf("login time      |%4s%4s%4s%4s%4s%4s%4s" ,$1,$2,$3,$4,$5,$6,$7)}'`
WLOGINTIMES=`echo ${WEEKLOGINSTRING} | \
           awk '{printf("number of times |%4s%4s%4s%4s%4s%4s%4s" ,$1,$2,$3,$4,$5,$6,$7)}'`

DAYLOGIN=($(last | awk '$3=="mosh" {print $8} $4=="vi" {print $8} \
         $4=="via" {if($5 == "mos" || $5 == "mo") print $9} \
         $4=="via" {if($5 != "mosh" && $5 != "mos" && $5 != "mo") print $8}  \
         $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}' | awk -F ":" '{print $1}' | \
         sort | uniq -c | awk '{print $2 "\t" $1}'))
DAYLOGINTIMESLIST=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
for (( i = 0; i<${#DAYLOGIN[@]};i++)); do
  if [ ${DAYLOGIN[i]} == "00" ]; then
    DAYLOGINTIMESLIST[0]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "01" ]; then
    DAYLOGINTIMESLIST[1]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "02" ]; then
    DAYLOGINTIMESLIST[2]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "03" ]; then
    DAYLOGINTIMESLIST[3]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "04" ]; then
    DAYLOGINTIMESLIST[4]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "05" ]; then
    DAYLOGINTIMESLIST[5]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "06" ]; then
    DAYLOGINTIMESLIST[6]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "07" ]; then
    DAYLOGINTIMESLIST[7]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "08" ]; then
    DAYLOGINTIMESLIST[8]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "09" ]; then
    DAYLOGINTIMESLIST[9]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "10" ]; then
    DAYLOGINTIMESLIST[10]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "11" ]; then
    DAYLOGINTIMESLIST[11]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "12" ]; then
    DAYLOGINTIMESLIST[12]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "13" ]; then
    DAYLOGINTIMESLIST[13]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "14" ]; then
    DAYLOGINTIMESLIST[14]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "15" ]; then
    DAYLOGINTIMESLIST[15]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "16" ]; then
    DAYLOGINTIMESLIST[16]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "17" ]; then
    DAYLOGINTIMESLIST[17]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "18" ]; then
    DAYLOGINTIMESLIST[18]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "19" ]; then
    DAYLOGINTIMESLIST[19]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "20" ]; then
    DAYLOGINTIMESLIST[20]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "21" ]; then
    DAYLOGINTIMESLIST[21]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "22" ]; then
    DAYLOGINTIMESLIST[22]=${DAYLOGIN[$(($i+1))]}
  elif [ ${DAYLOGIN[i]} == "23" ]; then
    DAYLOGINTIMESLIST[23]=${DAYLOGIN[$(($i+1))]}
  fi
done
for (( j = 0; j<${#DAYLOGINTIMESLIST[@]};j++)); do
  DAYLOGINSTRING="$DAYLOGINSTRING${DAYLOGINTIMESLIST[j]} "
done
HOURS="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
DLOGINHOUR=`echo ${HOURS} | \
            awk '{printf("login time      |%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s" \
            ,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24)}'`
DLOGINTIMES=`echo ${DAYLOGINSTRING} | \
             awk '{printf("number of times |%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s%4s" \
             ,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24)}'`

# Program : rank all user's commands

TOTAL=0    #Count how many commands
TEMP="$(mktemp rankCommandResult.XXXXXXX)"
TEMPSEC="$(mktemp rankSpaceResult.XXXXXXX)"

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

#Rank Space
RANKSPACE=`awk '{if(($3 != NULL)&&($1 != NULL))print $1 "k\t" $3}' $TEMPSEC | \
           sort -n -r | head -n 10 | awk '{printf ("%3s%12s%7s\n", NR, $2, $1)}'`
rm $TEMPSEC

if [ `whoami` == "root" ];then

  ${ECHO} -e "\nTOTAL number of commands : $TOTAL\n
Ranked commands of all users in record:\n${RANK}\n\n
Ranked space of all users : \nNo.\tUser\tSpace\n${RANKSPACE}\n" >> userInformation.txt

fi

${ECHO} -e "\nRank user's login times : \nNo.\tUser\tTimes\n${RANKLOGIN}\n
Daily login distribution :\n
  ${DLOGINHOUR}
  -----------------------------------------------------------------------------------------------------------------
  ${DLOGINTIMES}\n
Weekly login distribution :\n
  ${WLOGINDAY}
  ---------------------------------------------
  ${WLOGINTIMES}\n" >> userInformation.txt

${ECHO} -e "Done.\n"
