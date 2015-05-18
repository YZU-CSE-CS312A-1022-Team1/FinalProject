#!/bin/bash

exportUserAccount(){
  echo -n "var userlist='[" >> ${JSONFILE}
  for (( i=0; i<${#USERLIST[@]}; i++ )); do
    if [ $i != $((${#USERLIST[@]} -1)) ]; then
      echo -n "\"${USERLIST[$i]}\"," >> ${JSONFILE}
    else
      echo -n "\"${USERLIST[$i]}\"" >> ${JSONFILE}
    fi
  done
  echo "]';" >> ${JSONFILE}
}

DIR="results"
mkdir -p $DIR && cd $DIR

#Export user account list into json file
JSONFILE="userList.json"
if [ -e ${JSONFILE} ]; then
  rm ${JSONFILE}
fi

#Determine whether executor is root or not
#Get user accounts login in this month
WHO=`whoami`
if [ $WHO == "root" ]; then
  USERLIST=(`last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort -r | uniq`)
  NUMOFUSER=`echo -e "${#USERLIST[@]}" | wc -l | awk '{print $1}'`
  echo "program will analyze $NUMOFUSER user who has login in this month."
  echo "please wait "
else
  USERLIST=($USER)
  echo "You do not have root permission, program will not scan all the user info but only yours."
fi
exportUserAccount

#Call userAnalysis.sh to analyze user information
if [ ${#USERLIST[@]} == 0 ]; then
  echo "No user has login this month, the analyze will stop."
else
  for account in ${USERLIST}
  do
    ./../userAnalysis.sh ${account}
  done
fi
echo -e "\nAnalysis has been completed!"
