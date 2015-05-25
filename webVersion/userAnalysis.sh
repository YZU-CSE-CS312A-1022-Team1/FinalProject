#!/bin/bash

exportCommandRank(){
echo "var commands=['${COMMANDRANK_COMMAND[0]}','${COMMANDRANK_COMMAND[1]}','${COMMANDRANK_COMMAND[2]}',\
'${COMMANDRANK_COMMAND[3]}','${COMMANDRANK_COMMAND[4]}','${COMMANDRANK_COMMAND[5]}','${COMMANDRANK_COMMAND[6]}',\
'${COMMANDRANK_COMMAND[7]}','${COMMANDRANK_COMMAND[8]}','${COMMANDRANK_COMMAND[9]}'];" >> ${HTMLFILE}
}
exportCommandRankTimes(){
echo "var command_times=[${COMMANDRANK_TIMES[0]},${COMMANDRANK_TIMES[1]},${COMMANDRANK_TIMES[2]},\
${COMMANDRANK_TIMES[3]},${COMMANDRANK_TIMES[4]},${COMMANDRANK_TIMES[5]},${COMMANDRANK_TIMES[6]},\
${COMMANDRANK_TIMES[7]},${COMMANDRANK_TIMES[8]},${COMMANDRANK_TIMES[9]}];" >> ${HTMLFILE}
}
exportDailyLoginTimes(){
echo "var login_times_day=[${DAYLOGIN[0]},${DAYLOGIN[1]},${DAYLOGIN[2]},${DAYLOGIN[3]},${DAYLOGIN[4]},${DAYLOGIN[5]},\
${DAYLOGIN[6]},${DAYLOGIN[7]},${DAYLOGIN[8]},${DAYLOGIN[9]},${DAYLOGIN[10]},${DAYLOGIN[11]},${DAYLOGIN[12]},\
${DAYLOGIN[13]},${DAYLOGIN[14]},${DAYLOGIN[15]},${DAYLOGIN[16]},${DAYLOGIN[17]},${DAYLOGIN[18]},${DAYLOGIN[19]},\
${DAYLOGIN[20]},${DAYLOGIN[21]},${DAYLOGIN[22]},${DAYLOGIN[23]}];" >> ${HTMLFILE}
}
exportWeeklyLoginTimes(){
echo "var login_times_week=[${WEEKLOGIN[0]},${WEEKLOGIN[1]},${WEEKLOGIN[2]},${WEEKLOGIN[3]},\
${WEEKLOGIN[4]},${WEEKLOGIN[5]},${WEEKLOGIN[6]}];" >> ${HTMLFILE}
}
countDailyLoginTimes(){
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
#choose latest hestory
chooseCMDHistiryFile(){
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
}

#generate a directory to place the pages
DIRECTORY="userInfo"
if [ ! -d ${DIRECTORY} ]; then
  mkdir ${DIRECTORY}
fi

ACCOUNT=$1
HOME=`eval echo ~${ACCOUNT}`
HTMLFILE="${DIRECTORY}/${ACCOUNT}.html"

if [ -f ${HTMLFILE} ];then
  rm ${HTMLFILE}
fi

#os dependent command usage
if [ `uname` = "FreeBSD" ];then
  PS="ps -auU"
else
  PS="ps uU"
fi

if [ -d ${HOME} ]; then

  NUMOFDIR=`find ${HOME} -type d | wc -l | tr -d ' '`
  NUMOFFLE=`find ${HOME} -type f | wc -l | tr -d ' '`
  SPACE="`du -h -d 0 ${HOME} | awk '{print $1}'`B"

  chooseCMDHistiryFile
  TOTALCOMMAND=`wc -l ${LATESTHISTORY} | awk '{print $1}'`
  FAVCOMMAND=`cat -v ${LATESTHISTORY} | sed 's/\^@//g' | sed 's/\^A//g' | sed 's/\M-//g' | sed '/^$/d' | \
              awk '{print $1}'| sed '/#/d' | sort | uniq -c | sort -nr | head -n 10`
  COMMANDRANK_COMMAND=(`echo ${FAVCOMMAND} | awk '{print $2" "$4" "$6" "$8" "$10" "$12" "$14" "$16" "$18" "$20}'`)
  COMMANDRANK_TIMES=(`echo ${FAVCOMMAND} | awk '{print $1" "$3" "$5" "$7" "$9" "$11" "$13" "$15" "$17" "$19}'`)
fi

  if [ -f ${HTMLFILE} ];then
    rm ${HTMLFILE}
  fi

  SHELL=`finger ${ACCOUNT} | grep Shell | awk '{print $4}' | awk -F"/" '{print $NF}'`
  LOGINTIMES=`last | grep ${ACCOUNT} | wc -l | tr -d ' '`
  LASTLOGIN=`last |grep ${ACCOUNT} | head -n 1 | \
             awk '{ if (match($2, /^pts/)) { if ($3 != "mosh" && $5 != "mosh") {print $4, $5, $6, $7 " from " $3} \
             else { if ($5 == "mosh"){print $6, $7, $8, $9 " from " $3} else {print $5, $6, $7, $8" from " $3}}} \
             else {print $3, $4, $5, $6 " from " $2}}'`
  LOGINHOUR=`echo -e "$(last | grep ${ACCOUNT} | awk '{print $7, $1}' | awk -F ":" '$1 < 24 {print $1, $2}' | \
             awk '{if(($1 > 0)&&($1 <= 24))print $1}')"`
  LOGINDAY=`echo -e "$(last | grep ${ACCOUNT} |  awk '$3=="mosh" {print $5} $4=="vi" {print $5} $4=="via" \
            {if($5 != "mosh") print $5} $4=="via" {if($5 == "mosh") print $6} NF==10 {print $4}')"`
  DAYLOGIN=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  WEEKLOGIN=(0 0 0 0 0 0 0)
  countDailyLoginTimes
  countWeeklyLoginTimes
  DAYOFMONTH=`date +"%d"`
  LOGINFREQUENCY=`echo $(bc<<<"scale=3;$LOGINTIMES/$DAYOFMONTH" | awk '{printf "%1.3f", $0}')`
  if [ `ps au | grep ^${ACCOUNT} | wc -l |awk '{print $1}'` != 0 ]; then
    CURRENTPROCESS=`${PS} ${ACCOUNT} | awk '{printf( \
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
  " >> ${HTMLFILE}
  exportCommandRank
  exportCommandRankTimes
  exportDailyLoginTimes
  exportWeeklyLoginTimes
  echo "</head>
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
  <div class='title'><h1> ${ACCOUNT} </h1></div>
  <div class='c_body'><hr>
  <div class='leftblock'>
  <table>
  <tr><td width=320>Amount of directories under user's home:</td><td> $NUMOFDIR </td></tr>
  <tr><td>Amount of files under user's home:</td><td> $NUMOFFLE </td></tr>
  <tr><td>Default shell of this user:</td><td> $SHELL </td></tr>
  <tr><td>Last login time: </td><td> $LASTLOGIN </td></tr>
  <tr><td>Login times of this month:</td><td> $LOGINTIMES </td></tr>
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
