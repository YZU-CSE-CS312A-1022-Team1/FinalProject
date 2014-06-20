#!/bin/bash

DIR="results"
HTMLFILE="userSumUp.html"
mkdir -p $DIR && cd $DIR

#sorted login times
RANKLOGIN=`last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}' |\
           sort | uniq -c |sort -rn`

WEEKLOGIN=`last | awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
           $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}'| sort | uniq -c | \
           awk '$2 == "Mon" {print "1", $2, $1} $2 == "Tue" {print "2", $2, $1} $2 == "Wed" {print "3", $2, $1} \
           $2 == "Thu" {print "4", $2, $1} $2 == "Fri" {print "5", $2, $1} $2 == "Sat" {print "6", $2, $1} \
           $2 == "Sun" {print "7", $2, $1}' | sort -n | awk '{print $2, $3}'`
DAYLOGIN=`last | awk '$3=="mosh" {print $8} $4=="vi" {print $8} $4=="via" {if($5 != "mosh") print $8} \
          $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}' | awk -F ":" '{print $1}' | \
          sort | uniq -c | awk '{print $2 "\t" $1}'`

#put sorted login times username in an arrary
LOGINRANK_USER=`echo ${RANKLOGIN} | awk '{print $2" "$4" "$6" "$8" "$10}'`
LOGINRANK_USERLIST=($LOGINRANK_USER)

LOGINRANK_TIMES=`echo ${RANKLOGIN} | awk '{print $1" "$3" "$5" "$7" "$9}'`
LOGINRANK_TIMESLIST=($LOGINRANK_TIMES)

WEEK_LOGIN_TIMES=`echo ${WEEKLOGIN} | \
                  awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14 }'`
WEEK_LOGIN_DAYS=`echo ${WEEKLOGIN} | \
                  awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13 }'`
WEEK_LOGIN_TIMESLIST=($WEEK_LOGIN_TIMES)
WEEK_LOGIN_DAYSLIST=($WEEK_LOGIN_DAYS)

DAY_LOGIN_TIMES=`echo ${DAYLOGIN} | \
                 awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14" "$16" "$18" "$20" "$22" "$24 \
                 " "$26" "$28" "$30" "$32" "$34" "$36" "$38" "$40" "$42" "$44" "$46" "$48 }'`
DAY_LOGIN_HOURS=`echo ${DAYLOGIN} | \
                 awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13" "$15" "$17" "$19" "$21" "$23 \
                 " "$25" "$27" "$29" "$31" "$33" "$35" "$37" "$39" "$41" "$43" "$45" "$47 }'`
DAY_LOGIN_TIMESLIST=($DAY_LOGIN_TIMES)
DAY_LOGIN_HOURSLIST=($DAY_LOGIN_HOURS)

#Count how many used commands saved in system
TOTAL=0    #Count how many commands
TEMP_COMMAND="$(mktemp ALLCOMMAND.XXXXXXX)" #keep all commands from all user
TEMP_SPACE="$(mktemp ALLSPACE.XXXXXXX)" #keep all space usage from all user

if [ `whoami` == "root" ];then
  ALLUSER=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq)
else
  ALLUSER=`whoami`
fi

for username in $ALLUSER
  do
    USER=$username
    HOME=`eval echo ~${USER}`

    #COMMAND RANK
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

    if [ -r ${LATESTHISTORY} ];then
         FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' |\
                     awk '{print $1}'| sed '/#/d' | sort`
         echo -e "\n${FAVCOMMAND}" >> $TEMP_COMMAND    #write file
         COUNT="`wc -l ${LATESTHISTORY} | awk '{print $1}'`"
         TOTAL=$((${COUNT}+$TOTAL))
    fi

    #SAPCE RANK
    if [ -d  ${HOME} ]; then
      if [ -r ${HOME} ];then
        SPACES=`du -ks ${HOME}`
        echo -e "${SPACES} $username" >> $TEMP_SPACE
      fi
    fi
done

ALLCOMMAND=`echo $(awk '{print $1}' $TEMP_COMMAND | sort | uniq -c | sort -n -r)`
COMMANDRANK_COMMAND=`echo ${ALLCOMMAND} | awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14" "$16" "$18" "$20}'`
COMMANDRANK_TIMES=`echo ${ALLCOMMAND} | awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13" "$15" "$17" "$19}'`
COMMANDRANK_COMMANDLIST=($COMMANDRANK_COMMAND)
COMMANDRANK_TIMESLIST=($COMMANDRANK_TIMES)

SORTEDSPACE=`echo $(awk '{print $1/1024 "\t" $3}' $TEMP_SPACE | sort -n -r)`
SPACERANK_USER=`echo ${SORTEDSPACE} | awk '{print $2" "$4" "$6" "$8" "$10}'`
SPACERANK_USEAGE=`echo ${SORTEDSPACE} | awk '{printf("%.2f %.2f %.2f %.2f% .2f",$1,$3,$5,$7,$9)}'`
SPACERANK_USERLIST=($SPACERANK_USER)
SPACERANK_USEAGELIST=($SPACERANK_USEAGE)

  if [ -e $HTMLFILE ]; then
    rm $HTMLFILE
  fi

  echo "<html><head><meta http-equiv='content-Type' content='text/html; charset=UTF-8' />
        <title>CS312A - Introduction to UNIX System - Team project</title>
        <link rel='stylesheet' media='screen,print' href='css/layout.css' />
        <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js'></script>
        <script type='text/javascript' src='//cdn.jsdelivr.net/highcharts/4.0.1/highcharts.js'></script>
        <script type='text/javascript' src='userList.json'></script>
        <script type='text/javascript' src='js/userList.js'></script>
        <script type='text/javascript' src='js/userRank.js'></script>
        <script language=javascript>
       " >> ${HTMLFILE}

  echo "var username = JSON.parse(userlist);" >> ${HTMLFILE}
  echo -n "var login_rank_user = ["            >> ${HTMLFILE}
    for (( i=0; i<${#LOGINRANK_USERLIST[@]}; i++ )); do
      if [ $i != $((${#LOGINRANK_USERLIST[@]} -1)) ]; then
        echo -n "\"${LOGINRANK_USERLIST[$i]}\",">> ${HTMLFILE}
      else
        echo -n "\"${LOGINRANK_USERLIST[$i]}\"" >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo -n "var login_times = ["                 >> ${HTMLFILE}
    for (( i=0; i<${#LOGINRANK_TIMESLIST[@]}; i++ )); do
      if [ $i != $((${#LOGINRANK_TIMESLIST[@]} -1)) ]; then
        echo -n "${LOGINRANK_TIMESLIST[$i]},"   >> ${HTMLFILE}
      else
        echo -n "${LOGINRANK_TIMESLIST[$i]}"    >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo "var total_commands = $TOTAL;"           >> ${HTMLFILE}

  echo -n "var commands = ["                    >> ${HTMLFILE}
    for (( i=0; i<${#COMMANDRANK_COMMANDLIST[@]}; i++ )); do
      if [ $i != $((${#COMMANDRANK_COMMANDLIST[@]} -1)) ]; then
        echo -n "\"${COMMANDRANK_COMMANDLIST[$i]}\","     >> ${HTMLFILE}
      else
        echo -n "\"${COMMANDRANK_COMMANDLIST[$i]}\""      >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo -n "var command_times = ["               >> ${HTMLFILE}
    for (( i=0; i<${#COMMANDRANK_TIMESLIST[@]}; i++ )); do
      if [ $i != $((${#COMMANDRANK_TIMESLIST[@]} -1)) ]; then
        echo -n "${COMMANDRANK_TIMESLIST[$i]}," >> ${HTMLFILE}
      else
        echo -n "${COMMANDRANK_TIMESLIST[$i]}"  >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo -n "var space_rank_user = ["             >> ${HTMLFILE}
    for (( i=0; i<${#SPACERANK_USERLIST[@]}; i++ )); do
      if [ $i != $((${#SPACERANK_USERLIST[@]} -1)) ]; then
        echo -n "\"${SPACERANK_USERLIST[$i]}\",">> ${HTMLFILE}
      else
        echo -n "\"${SPACERANK_USERLIST[$i]}\"" >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo -n "var space_usage = ["                 >> ${HTMLFILE}
    for (( i=0; i<${#SPACERANK_USEAGELIST[@]}; i++ )); do
      if [ $i != $((${#SPACERANK_USEAGELIST[@]} -1)) ]; then
        echo -n "${SPACERANK_USEAGELIST[$i]},"  >> ${HTMLFILE}
      else
        echo -n "${SPACERANK_USEAGELIST[$i]}"   >> ${HTMLFILE}
      fi
    done
  echo "];" >> ${HTMLFILE}

  echo "var login_times_day=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];" >> ${HTMLFILE}

    for (( i=0; i<${#DAY_LOGIN_HOURSLIST[@]}; i++ )); do
      if [ ${DAY_LOGIN_HOURSLIST[$i]}  == "00" ]; then
        echo "login_times_day[0] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "01" ]; then
        echo "login_times_day[1] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "02" ]; then
        echo "login_times_day[2] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "03" ]; then
        echo "login_times_day[3] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "04" ]; then
        echo "login_times_day[4] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "05" ]; then
        echo "login_times_day[5] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "06" ]; then
        echo "login_times_day[6] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "07" ]; then
        echo "login_times_day[7] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "08" ]; then
        echo "login_times_day[8] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "09" ]; then
        echo "login_times_day[9] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "10" ]; then
        echo "login_times_day[10] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "11" ]; then
        echo "login_times_day[11] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "12" ]; then
        echo "login_times_day[12] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "13" ]; then
        echo "login_times_day[13] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "14" ]; then
        echo "login_times_day[14] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "15" ]; then
        echo "login_times_day[15] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "16" ]; then
        echo "login_times_day[16] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "17" ]; then
        echo "login_times_day[17] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "18" ]; then
        echo "login_times_day[18] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "19" ]; then
        echo "login_times_day[19] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "20" ]; then
        echo "login_times_day[20] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "21" ]; then
        echo "login_times_day[21] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "22" ]; then
        echo "login_times_day[22] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      elif [ ${DAY_LOGIN_HOURSLIST[$i]}  == "23" ]; then
        echo "login_times_day[23] = ${DAY_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
      fi
    done

  echo "var login_times_week=[0,0,0,0,0,0,0];" >> ${HTMLFILE}

  for (( i=0 ; i<${#WEEK_LOGIN_DAYSLIST[@]} ;i++ )); do
    if [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Mon" ]; then
      echo "login_times_week[0] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Tue" ]; then
      echo "login_times_week[1] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Wed" ]; then
      echo "login_times_week[2] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Thu" ]; then
      echo "login_times_week[3] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Fri" ]; then
      echo "login_times_week[4] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Sat" ]; then
      echo "login_times_week[5] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
    elif [ "${WEEK_LOGIN_DAYSLIST[$i]}"  == "Sun" ]; then
      echo "login_times_week[6] = ${WEEK_LOGIN_TIMESLIST[$i]} ;" >> ${HTMLFILE}
   fi
  done

  echo "
        </script>
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
