#!/bin/bash

exportLoginDistributionAndRankings(){
  nameOfVar=("login_rank_user" "login_times" "space_rank_user" "space_usage" "commands" "command_times" \
             "login_times_day" "login_times_week")
  listOfList=(${LOGINRANK_USER[@]} ${LOGINRANK_TIMES[@]} ${SPACERANK_USER[@]} ${SPACERANK_USEAGE[@]} \
              ${COMMANDRANK_COMMAND[@]} ${COMMANDRANK_TIMES[@]} ${DAYLOGIN[@]} ${WEEKLOGIN[@]})
  counter=0
  indexOfList=0
  for (( index=0; index<${#listOfList[@]} ; index++ )); do
    if [ $counter == 0 ]; then
      echo -n "var ${nameOfVar[$indexOfList]} = [" >> ${HTMLFILE}
    fi
    counter=$(( $counter +1 ))

    if [ $indexOfList == 0 ] && [ $counter == ${#LOGINRANK_USER[@]} ]; then
      echo "'${listOfList[$index]}'];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 1 ] && [ $counter == ${#LOGINRANK_TIMES[@]} ]; then
      echo "${listOfList[$index]}];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 2 ] && [ $counter == ${#SPACERANK_USER[@]} ]; then
      echo "'${listOfList[$index]}'];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 3 ] && [ $counter == ${#SPACERANK_USEAGE[@]} ]; then
      echo "${listOfList[$index]}];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 4 ] && [ $counter == ${#COMMANDRANK_COMMAND[@]} ]; then
      echo "'${listOfList[$index]}'];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 5 ] && [ $counter == ${#COMMANDRANK_TIMES[@]} ]; then
      echo "${listOfList[$index]}];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 6 ] && [ $counter == ${#DAYLOGIN[@]} ]; then
      echo "${listOfList[$index]}];" >> ${HTMLFILE}
      indexOfList=$(($indexOfList+1))
      counter=0
    elif [ $indexOfList == 7 ] && [ $counter == ${#WEEKLOGIN[@]} ]; then
      echo "${listOfList[$index]}];" >> ${HTMLFILE}
    elif [ $(($indexOfList%2)) == 0 ] && [ $indexOfList -ne 6 ]; then
      echo -n "'${listOfList[$index]}', " >> ${HTMLFILE}
    else
      echo -n "${listOfList[$index]}, " >> ${HTMLFILE}
    fi
  done
}
countDailyLoginTimes(){
  DAYLOGIN=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  for HOUR in $LOGINHOUR
  do
    case $HOUR in
      "00")
        DAYLOGIN[0]=$(( ${DAYLOGIN[0]} +1 ));;
      "01")
        DAYLOGIN[1]=$(( ${DAYLOGIN[1]} +1 ));;
      "02")
        DAYLOGIN[2]=$(( ${DAYLOGIN[2]} +1 ));;
      "03")
        DAYLOGIN[3]=$(( ${DAYLOGIN[3]} +1 ));;
      "04")
        DAYLOGIN[4]=$(( ${DAYLOGIN[4]} +1 ));;
      "05")
        DAYLOGIN[5]=$(( ${DAYLOGIN[5]} +1 ));;
      "06")
        DAYLOGIN[6]=$(( ${DAYLOGIN[6]} +1 ));;
      "07")
        DAYLOGIN[7]=$(( ${DAYLOGIN[7]} +1 ));;
      "08")
        DAYLOGIN[8]=$(( ${DAYLOGIN[8]} +1 ));;
      "09")
        DAYLOGIN[9]=$(( ${DAYLOGIN[9]} +1 ));;
      "10")
        DAYLOGIN[10]=$(( ${DAYLOGIN[10]} +1 ));;
      "11")
        DAYLOGIN[11]=$(( ${DAYLOGIN[11]} +1 ));;
      "12")
        DAYLOGIN[12]=$(( ${DAYLOGIN[12]} +1 ));;
      "13")
        DAYLOGIN[13]=$(( ${DAYLOGIN[13]} +1 ));;
      "14")
        DAYLOGIN[14]=$(( ${DAYLOGIN[14]} +1 ));;
      "15")
        DAYLOGIN[15]=$(( ${DAYLOGIN[15]} +1 ));;
      "16")
        DAYLOGIN[16]=$(( ${DAYLOGIN[16]} +1 ));;
      "17")
        DAYLOGIN[17]=$(( ${DAYLOGIN[17]} +1 ));;
      "18")
        DAYLOGIN[18]=$(( ${DAYLOGIN[18]} +1 ));;
      "19")
        DAYLOGIN[19]=$(( ${DAYLOGIN[19]} +1 ));;
      "20")
        DAYLOGIN[20]=$(( ${DAYLOGIN[20]} +1 ));;
      "21")
        DAYLOGIN[21]=$(( ${DAYLOGIN[21]} +1 ));;
      "22")
        DAYLOGIN[22]=$(( ${DAYLOGIN[22]} +1 ));;
      "23")
        DAYLOGIN[23]=$(( ${DAYLOGIN[23]} +1 ));;
    esac
  done
}
countWeeklyLoginTimes(){
  WEEKLOGIN=(0 0 0 0 0 0 0)
  for DAY in $LOGINDAY
  do
    case $DAY in
      "Mon")
        WEEKLOGIN[0]=$(( ${WEEKLOGIN[0]} +1 ));;
      "Tue")
        WEEKLOGIN[1]=$(( ${WEEKLOGIN[1]} +1 ));;
      "Wed")
        WEEKLOGIN[2]=$(( ${WEEKLOGIN[2]} +1 ));;
      "Thu")
        WEEKLOGIN[3]=$(( ${WEEKLOGIN[3]} +1 ));;
      "Fri")
        WEEKLOGIN[4]=$(( ${WEEKLOGIN[4]} +1 ));;
      "Sat")
        WEEKLOGIN[5]=$(( ${WEEKLOGIN[5]} +1 ));;
      "Sun")
        WEEKLOGIN[6]=$(( ${WEEKLOGIN[6]} +1 ));;
    esac
  done
}

DIR="results"
HTMLFILE="userSumUp.html"
mkdir -p $DIR && cd $DIR

#Sorted user login times
RANKLOGIN=`last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}' |\
           sort | uniq -c |sort -rn`
LOGINRANK_USER=(`echo ${RANKLOGIN} | awk '{print $2" "$4" "$6" "$8" "$10}'`)
LOGINRANK_TIMES=(`echo ${RANKLOGIN} | awk '{print $1" "$3" "$5" "$7" "$9}'`)

LOGINHOUR=`echo -e "$(last | awk '$3=="mosh" {print $8} $4=="vi" {print $8} $4=="via" {if($5 != "mosh") print $8} \
           $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}' | awk -F ":" '{print $1}' | \
           awk '{print $2 "\t" $1}')"`
LOGINDAY=`echo -e "$(last | awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
          $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}'| sort )"`
countDailyLoginTimes
countWeeklyLoginTimes

#use temp file to count used commands and space usage
TOTAL=0    #Count how many commands
TEMP_COMMAND="$(mktemp ALLCOMMAND.XXXXXXX)" #keep all commands from all user
TEMP_SPACE="$(mktemp ALLSPACE.XXXXXXX)" #keep all space usage from all user

#Count the commands and space usage individually
if [ `whoami` == "root" ];then
  USERLIST=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)
else
  USERLIST=`whoami`
fi

for username in $USERLIST
do
  ACCOUNT=$username
  HOME=`eval echo ~${ACCOUNT}`

  #Find command history file
  if [ ${HOME}/.bash_history -nt ${HOME}/.history ] && [ ${HOME}/.bash_history -nt ${HOME}/.histfile ] \
    && [ ${HOME}/.bash_history -nt ${HOME}/.sh_history ]; then
      LATESTHISTORY=`echo "${HOME}/.bash_history"`
  elif [ ${HOME}/.history -nt ${HOME}/.bash_history ] && [ ${HOME}/.history -nt ${HOME}/.histfile ] \
    && [ ${HOME}/.history -nt ${HOME}/.sh_history ]; then
      LATESTHISTORY=`echo "${HOME}/.history"`
  elif [ ${HOME}/.histfile -nt ${HOME}/.bash_history ] && [ ${HOME}/.histfile -nt ${HOME}/.history ] \
    && [ ${HOME}/.histfile -nt ${HOME}/.sh_history ]; then
      LATESTHISTORY=`echo "${HOME}/.histfile"`
  else
      LATESTHISTORY=`echo "${HOME}/.sh_history"`
  fi

  #Collect common used command
  if [ -r ${LATESTHISTORY} ];then
    FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' |\
                awk '{print $1}'| sed '/#/d' | sort`
    echo -e "\n${FAVCOMMAND}" >> $TEMP_COMMAND    #write file
    COUNT="`wc -l ${LATESTHISTORY} | awk '{print $1}'`"
    TOTAL=$((${COUNT}+$TOTAL))
  fi

  #Collect space usage
  if [ -d  ${HOME} ]; then
    if [ -r ${HOME} ];then
      SPACES=`du -ks ${HOME}`
      echo -e "${SPACES} ${ACCOUNT}" >> $TEMP_SPACE
    fi
  fi
done

#Sort the commands and space usage ranking
SORTEDSPACE=`echo $(awk '{print $1/1024 "\t" $3}' $TEMP_SPACE | sort -n -r)`
SPACERANK_USER=(`echo ${SORTEDSPACE} | awk '{print $2" "$4" "$6" "$8" "$10}'`)
SPACERANK_USEAGE=(`echo ${SORTEDSPACE} | awk '{printf("%.2f %.2f %.2f %.2f% .2f",$1,$3,$5,$7,$9)}'`)

ALLCOMMAND=`echo $(awk '{print $1}' $TEMP_COMMAND | sort | uniq -c | sort -n -r)`
COMMANDRANK_COMMAND=(`echo ${ALLCOMMAND} | awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14" "$16" "$18" "$20}'`)
COMMANDRANK_TIMES=(`echo ${ALLCOMMAND} | awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13" "$15" "$17" "$19}'`)

if [ -e $HTMLFILE ]; then
  rm $HTMLFILE
fi

echo "<html><head><meta http-equiv='content-Type' content='text/html; charset=UTF-8' />
      <title>`hostname` - User behavior analysis</title>
      <link rel='stylesheet' media='screen,print' href='css/layout.css' />
      <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
      <script type='text/javascript' src='//cdnjs.cloudflare.com/ajax/libs/highcharts/4.1.4/highcharts.js'></script>
      <script type='text/javascript' src='userList.json'></script>
      <script type='text/javascript' src='js/userList.js'></script>
      <script type='text/javascript' src='js/userRank.js'></script>
      <script language=javascript>
      " >> ${HTMLFILE}

echo "var total_commands = $TOTAL;"           >> ${HTMLFILE}
exportLoginDistributionAndRankings

echo "</script>
      </head>
      <body>
      <div id='menu'>
      <ul><div class='sidebar'>
      <li><a href='index.html'>System Info</a></li>
      <li><a href='networkTraffic.html'>Network Traffic</a></li>
      <li><a href='userSumUp.html'>User Summary</a></li>
      <li style='text-decoration: none' onMouseOver='javascript:extend_2(\"user\")'>User Info</li>
      </div>
      <div id=user style='display: none'>
      <ul class='hvr'>
      <div id='userlist_other'></div>
      </ul></div></ul></div>
      <div id='content'>
      <div class='title'>
      <h1>Summary</h1></div>
      <div class='c_body'><hr>
      <div class='leftblock'>
      <table><tr><td colspan=2><h2>Daily login time distribution</h2></td></tr>
      <tr><td>
      <div id='login_in_day' style='width: 800px; height: 250px; margin: 0 0 0 0px'></div>
      </td></tr>
      </table>
      <table><tr><td colspan=2><h2>Weekily login day distribution</h2></td></tr>
      <tr><td>
      <div id='login_in_week' style='width: 700px; height: 250px; margin: 0 0 0 0px'></div>
      </td></tr>
      </table>
      <table><tr><td colspan=2><h2>Total login times</h2></td></tr>
      <tr><td>
      <div id='login_rank' style='width: 700px; height: 250px; margin: 0 0 0 0px'></div>
      </td></tr>
      </table>
      <table><tr><td colspan=2><h2>Commonly used command</h2></td></tr>
      <tr><td colspan='2'>Total number of commands : $TOTAL </td></tr>
      <tr><td colspan='2'>Ranked commands of all users in record:</td></tr>
      <tr><td>
      <div id='command_rank' style='width: 700px; height: 400px; margin: 20px 0 0 0px'></div>
      </td></tr>
      </table>
      <table><tr><td colspan=2><h2>Disk space usage</h2></td></tr>
      <tr><td>
      <div id='space_usage' style='width: 700px; height: 250px; margin: 0 0 0 0px'>
      </td></tr>
      </table>
      </div>
      </div>
      </body></html>
      "  >> ${HTMLFILE}

rm $TEMP_COMMAND $TEMP_SPACE
