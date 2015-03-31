#!/bin/bash

DIR="results"
mkdir -p $DIR && cd $DIR

WHO=`whoami`
if [ $WHO == "root" ]; then
  ALLUSER=`last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort -r | uniq`
  USERLIST=($ALLUSER)
else
  USERLIST=($USER)
fi

JSONFILE="userList.json"

if [ -e ${JSONFILE} ]; then
  rm ${JSONFILE}
fi
echo -n "var userlist='[" >> ${JSONFILE}
for (( i=0; i<${#USERLIST[@]}; i++ )); do
  if [ $i != $((${#USERLIST[@]} -1)) ]; then
    echo -n "\"${USERLIST[$i]}\"," >> ${JSONFILE}
  else
    echo -n "\"${USERLIST[$i]}\"" >> ${JSONFILE}
  fi
done
echo "]';" >> ${JSONFILE}

#os dependent command usage
if [ `uname` = "FreeBSD" ];then
    PS="ps -auU"
else
    PS="ps uU"
fi

#generate a directory to place the pages
DIRECTORY="userInfo"

if [ ! -d ${DIRECTORY} ];then
    mkdir ${DIRECTORY}
fi

WHO=`whoami`
if [ $WHO == "root" ]; then
  NUMOFUSER=`echo -e "${ALLUSER}" | wc -l | awk '{print $1}'`
  echo "program will analyze $NUMOFUSER user who has login in this month."
  echo -n "please wait "
else
  ALLUSER=($USER)
  echo "You do not have root permission, program will not scan all the user info but only yours."
fi

counter=0

#generate the web pages in loop
for username in $ALLUSER
  do
#    echo "Analyzing about user: $username"

    counter=$(($counter +1))
    if [ $(($counter%10)) == 0 ]; then
      echo -n " $counter "
    elif [ $(($counter%10%3)) == 0 ]; then
      echo -n "."
    fi

    USER=$username
    HOME=`eval echo ~${USER}`
    HTMLFILE="${DIRECTORY}/$username.html"

    #choose latest hestory
    if [ ${HOME}/.bash_history -nt ${HOME}/.history ] && [ ${HOME}/.bash_history -nt ${HOME}/.histfile ]\
       && [ ${HOME}/.bash_history -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.bash_history"`
    elif [ ${HOME}/.history -nt ${HOME}/.bash_history ] && [ ${HOME}/.history -nt ${HOME}/.histfile ] \
         && [ ${HOME}/.history -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.history"`
    elif [ ${HOME}/.histfile -nt ${HOME}/.bash_history ] && [ ${HOME}/.histfile -nt ${HOME}/.history ]\
         && [ ${HOME}/.histfile -nt ${HOME}/.sh_history ]; then
        LATESTHISTORY=`echo "${HOME}/.histfile"`
    else
        LATESTHISTORY=`echo "${HOME}/.sh_history"`
    fi

     if [ -r ${LATESTHISTORY} ];then
        if [ -f ${HTMLFILE} ];then
            rm ${HTMLFILE}
        fi

        SHELL=`finger ${USER} | grep Shell | awk '{print $4}' | awk -F"/" '{print $NF}'`
        NUMOFDIR=`find ${HOME} -type d | wc -l | tr -d ' '`
        NUMOFFLE=`find ${HOME} -type f | wc -l | tr -d ' '`
        LOGINRECORD=`last | grep ${USER} | wc -l | tr -d ' '`
        LOGINTIME=`last | grep ${USER} | awk '{print $7, $1}' | awk -F ":" '$1 < 24 {print $1, $2}' | \
                   awk '{if(($1 > 0)&&($1 <= 24))print $1}' | sort| uniq -c | awk '{print $2 "\t\t" $1}'`
        LOGOUTTIME=`last | grep ${USER} | awk '{print $9, $1}' | awk -F ":" '$1 < 24 {print $1, $2}'| \
                   awk '{if(($1 > 0)&&($1 <= 24))print $1}' | sort | uniq -c |awk '{print $2 "\t\t" $1}'`
        LASTLOGIN=`last |grep ${USER} | head -n 1 | \
                   awk '{ if (match($2, /^pts/)) { if ($3 != "mosh" && $5 != "mosh") {print $4, $5, $6, $7 " from " $3} \
                   else { if ($5 == "mosh"){print $6, $7, $8, $9 " from " $3} else {print $5, $6, $7, $8" from " $3}}} \
                   else {print $3, $4, $5, $6 " from " $2}}'`
        DAYLOGIN=`last | grep ${USER} | awk '$3=="mosh" {print $8} $4=="vi" {print $8} \
                  $4=="via" {if($5 != "mosh") print $8} $4=="via" {if($5 == "mosh") print $9} NF==10 {print $7}'| \
                  awk -F ":" '{print $1}' | sort | uniq -c | awk '{print $2 "\t\t" $1}'`
        WEEKLOGIN=`last | grep ${USER} |
                   awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" {if($5 != "mosh") print $5} \
                   $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}'| sort | uniq -c | \
                   awk '$2 == "Mon" {print "1", $2, $1} $2 == "Tue" {print "2", $2, $1} $2 == "Wed" {print "3", $2, $1} \
                   $2 == "Thu" {print "4", $2, $1} $2 == "Fri" {print "5", $2, $1} $2 == "Sat" {print "6", $2, $1} \
                   $2 == "Sun" {print "7", $2, $1}' | sort -n | awk '{print $2, $3}'`
        TOTALCOMMAND=`wc -l ${LATESTHISTORY} | awk '{print $1}'`
        FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' | \
                    awk '{print $1}'| sed '/#/d' | sort | uniq -c | sort -nr | head -n 10`
        PROCESS=`${PS} ${USER} | awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}' | sed 's/\ /\'$'\t''/g' | sort -rg`
        DAYOFMONTH=`date +"%d"`
        SPACE="`du -h -d 0 ${HOME} | awk '{print $1}'`B"
    LOGINFREQUENCY=`echo $(bc<<<"scale=3;$LOGINRECORD/$DAYOFMONTH" | awk '{printf "%1.3f", $0}')`

    #string cutting, get the most used ten command and used times
    COMMANDRANK_COMMAND=`echo ${FAVCOMMAND} | awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14" "$16" "$18" "$20}'`
    COMMANDRANK_TIMES=`echo ${FAVCOMMAND} | awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13" "$15" "$17" "$19}'`
    COMMANDRANK_COMMANDLIST=($COMMANDRANK_COMMAND)
    COMMANDRANK_TIMESLIST=($COMMANDRANK_TIMES)

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
                     " "$25" "$27" "$29" "$31" "$33" "$35" "$37" "$39" "$41" "$43" "$45" "$47 }'`\
    DAY_LOGIN_TIMESLIST=($DAY_LOGIN_TIMES)
    DAY_LOGIN_HOURSLIST=($DAY_LOGIN_HOURS)
    if [ `ps au | grep ^${USER} | wc -l |awk '{print $1}'` != 0 ]; then
      CURRENTPROCESS=`${PS} ${USER} | awk '{printf( \
                       "<tr><td width=60>%-10s</td><td width=60>%-10s</td><td width=60>%-10s</td><td width=60>%-10s</td><td width=60>%-10s</td><td>%-10s</td></tr>" \
                       ,$2,$3,$4,$9,$10,$11)}' | sort -g`
    else
      CURRENTPROCESS="<tr><td>None.</td></tr>"
    fi

    echo "<html><head><meta http-equiv='content-Type' content='text/html; charset=UTF-8' />
          <title>`hostname` - User behavior analysis</title>
          <link rel='stylesheet' media='screen,print' href='../css/layout.css' />
          <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
          <script type='text/javascript' src='//cdnjs.cloudflare.com/ajax/libs/highcharts/4.1.4/highcharts.js'></script>
          <script type='text/javascript' src='../userList.json'></script>
          <script type='text/javascript' src='../js/userList.js'></script>
          <script language=javascript>
         " >> ${HTMLFILE}

        #put all username into array
        echo "var username = JSON.parse(userlist);" >> ${HTMLFILE}
        #put commands into array
        echo -n "var commands = [" >> ${HTMLFILE}
          for (( i=0; i<${#COMMANDRANK_COMMANDLIST[@]}; i++ )); do
            if [ $i != $((${#COMMANDRANK_COMMANDLIST[@]} -1)) ]; then
              echo -n "\"${COMMANDRANK_COMMANDLIST[$i]}\"," >> ${HTMLFILE}
            else
              echo -n "\"${COMMANDRANK_COMMANDLIST[$i]}\"" >> ${HTMLFILE}
            fi
          done
        echo "];" >> ${HTMLFILE}

        #put commands used times into array
        echo -n "var command_times = [" >> ${HTMLFILE}
          for (( i=0; i<${#COMMANDRANK_TIMESLIST[@]}; i++ )); do
            if [ $i != $((${#COMMANDRANK_TIMESLIST[@]} -1)) ]; then
              echo -n "${COMMANDRANK_TIMESLIST[$i]}," >> ${HTMLFILE}
            else
              echo -n "${COMMANDRANK_TIMESLIST[$i]}" >> ${HTMLFILE}
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

        echo "</script>
              </head>
              <body>
              <div id='menu'>
              <ul>
              <div class='sidebar'>
              <li><a href='../index.html'>System Info</a></li>
              <li><a href='../networkTraffic.html'>Network Traffic</a></li>
              <li><a href='../userSumUp.html'>User Summary</a></li>
              <li style='text-decoration: none' onMouseOver='javascript:extend_2(\"user\")'>User Info</li></div>
              <div id=user style='display: none'>
              <ul class='hvr'>
              <div id='userlist_user'></div>
              </ul></div></ul></div>
              <div id='content'>
              <div class='title'><h1> ${USER} </h1></div>
              <div class='c_body'><hr>
              <div class='leftblock'>
              <table>
              <tr><td width=320>Amount of directories under user's home:</td><td> $NUMOFDIR </td></tr>
              <tr><td>Amount of files under user's home:</td><td> $NUMOFFLE </td></tr>
              <tr><td>Default shell of this user:</td><td> $SHELL </td></tr>
              <tr><td>Last login time: </td><td> $LASTLOGIN </td></tr>
              <tr><td>Login times of this month:</td><td> $LOGINRECORD </td></tr>
              <tr><td>Login frequency of this month:</td><td> $LOGINFREQUENCY time(s)/day</td></tr>
              <tr><td>Disk space used:</td><td> $SPACE </td></tr>
              </table>
              <br>
              <table><tr><td colspan=2><h2>Daily Login Distribution </h2></td></tr>
              <tr><td>
              <div id='login_in_day' style='width: 800px; height: 250px; margin: 0 0 0 0px'></div>
              </td></tr>
              </table>
              <table><tr><td colspan=2><h2>Weekily Login Distribution</h2></td></tr>
              <tr><td>
              <div id='login_in_week' style='width: 700px; height: 250px; margin: 0 0 0 0px'></div>
              </td></tr>
              </table>
              <table><tr><td colspan='2'><h3>Most commonly used command</h3></td></tr>
              <tr><td colspan='2'>(analyzed by last $TOTALCOMMAND commands in record):</td></tr>
              <tr><td><br>
              <div id='user_command_chart' style='width: 800px; height: 350px; margin: 0 0 0 0px' ></div>
              </td></tr>
              </table>
              <br>
              <table><tr><td colspan='6'><h3>Currently running process:</h3></td></tr>
              $CURRENTPROCESS
              </table>
              </div>
              </div>
              </div>
              </body></html>
             " >> ${HTMLFILE}
  fi
done
echo -e "\nAnalysis is complete!"
