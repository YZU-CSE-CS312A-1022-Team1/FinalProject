#!/bin/bash

DIR="results"
HTMLFILE="index.html"

mkdir -p $DIR && cd $DIR

if [ -e $HTMLFILE ];then
  rm -f $HTMLFILE
fi


#add user who still logged in
USERLOGIN=`last | awk '{if($8 == "still"){print $1}}' | uniq | wc -l `

#add uptime
SYSTIME=`uptime | awk '{if(NF==12){print $2" "$3" "$4" "$5 } else if(NF==11){print $2" "$3" "$4} else if(NF==10){print $2" "$3}}' | sed 's/,//g'`

#Mem info
if [ `uname` = "Linux" ];then
  MEMORYINFO=$(free -h | sed -n '2p' | \
             awk '{print $1 "</td><td align=right width=100px>" $2 " total</td><td align=right width=100px>" \
             $3" used</td><td align=right width=100px>"$4" free</td><td align=right width=100px>" \
             $5" shared</td><td align=right width=130px>"$6" buffers</td><td align=right width=130px>"$7" cached" }')
  SWAPINFO=$(free -h | sed -n '4p' | \
           awk '{print $1 "</td><td align=right width=100px>" $2 " total</td><td align=right width=100px>" \
           $3" used</td><td align=right width=100px>"$4" free"}')
  CPUUSAGE=$(top -b -n 1| head -n 3 | tail -n 1 | \
           awk '{usr="";sys="";idle="";}{if(NF==17){usr=$2;sys=$4;idle=$8;}else{usr=$2;sys=$4;idle=100;}} \
           {print "usr:"usr"%</td><td width=100px>sys:"sys"%</td><td width=100px>idle:"idle"%"}')
  MODELNAME=$(cat /proc/cpuinfo | sed -n '2p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  FEATURES=$(cat /proc/cpuinfo | sed -n '3p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  CPUIMPLEMENTER=$(cat /proc/cpuinfo | sed -n '4p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  CPUARCH=$(cat /proc/cpuinfo | sed -n '5p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  CPUVAR=$(cat /proc/cpuinfo | sed -n '6p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  CPUPART=$(cat /proc/cpuinfo | sed -n '7p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  CPUREVISION=$(cat /proc/cpuinfo | sed -n '8p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  HW=$(cat /proc/cpuinfo | sed -n '10p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  REVEISION=$(cat /proc/cpuinfo | sed -n '11p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  SERIAL=$(cat /proc/cpuinfo | sed -n '12p'  | awk 'BEGIN {FS=": "}{print $1 ":</td><td>" $2}')
  SYSVERSION=`lsb_release -d | awk '{print $2, $3, $4, $5}'`
  NUMOFRUNNINGPROC=`ps -e | wc -l`

elif [ `uname` = "FreeBSD" ];then
  MEMORYINFO=$(top -b | head -n 4 | tail -n 1 | sed s/,//g | awk '{print $1"</td><td align=right width=120>"$2" "$3"</td><td align=right width=120>" \
             $4" "$5"</td><td align=right width=120>"$6" "$7"</td><td align=right  width=120>"$8" "$9"</td><td align=right width=120>"$10" "$11}')
  SWAPINFO=$(top -b | head -n 5 | tail -n 1 | sed s/,//g | awk '{print $1"</td><td align=right width=120>"$2" "$3"</td><td align=right width=120>" \
           $4" "$5}')
  CPUUSAGE=$(vmstat | tail -n 1 | \
           awk '{print "usr:" $17 "%</td><td width=100px>sys:" $18 "%</td><td width=100px>idle:" $19 "%"}')
  SYSVERSION=`uname -r`
  NUMOFRUNNINGPROC=`ps -a | wc -l`
  NUMOFCPU=$(sysctl -a | grep 'hw.ncpu' | awk '{print $2}')
  MODEL=$(sysctl -ae | grep 'hw.model' | awk 'FS="="{print $2}')
  SYSARCH=$(sysctl -a | grep 'hw.machine_arch' | awk '{print $2}')
  CPUTEMPERATURE=$(sysctl -a | grep 'dev.cpu.0.temperature' | awk '{print $2}')
  SYSVERSION=`uname -r`
  NUMOFRUNNINGPROC=`ps -a | wc -l`
fi

HOSTNAME=`hostname -s`
SYSNAME=`uname -s`
SYSPLATFORM=`uname -m`
KERNELVERSION=`uname -r`
LOADAVG=`uptime | awk '{if(NF==12){print $10" "$11" "$12} else if(NF==11){print $9" "$10" "$11} else if(NF==10){print $8" "$9" "$10}}'`
FILESYS_HEAD=$(df -h /etc |sed -n '1p'| awk '{print $1 "</td><td align=right width=120>" $2 "</td><td align=right width=120>" \
             $3 "</td><td align=right width=120>"$4"</td><td align=right width=120>" $5"</td><td align=right width=120>" $6}')
FILESYS_CONTENT=$(df -h /etc |sed -n '2p'| awk '{print $1 "</td><td align=right width=120>" $2 "</td><td align=right width=120>" \
                $3 "</td><td align=right width=120>"$4"</td><td align=right width=120>" $5"</td><td align=right width=120>" $6}')

#network traffic
TRAFFIC=`vnstat --oneline`
TRAFFIC_TODAY=$(echo ${TRAFFIC}| \
              awk 'BEGIN {FS=";"} {print "today</td><td align=right>" $4 "</td><td align=right>"$5"</td><td align=right>"$6}')
TRAFFIC_MONTH=$(echo ${TRAFFIC}| \
              awk 'BEGIN {FS=";"} {print $8"</td><td align=right>" $9 "</td><td align=right>" $10 "</td><td align=right>" $11}')


  if [ -e $HTMLFILE ];then
    rm $HTMLFILE
  fi

  echo "<html><head><meta http-equiv='content-Type' content='text/html; charset=UTF-8' />
        <title>`hostname` - User behavior analysis</title>
        <link rel='stylesheet' media='screen,print' href='css/layout.css' />
        <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
        <script type='text/javascript' src='userList.json'></script>
        <script type='text/javascript' src='js/userList.js'></script>
        <script language=javascript>
        var username = JSON.parse(userlist);
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
        <h1> $HOSTNAME's System Information </h1></div>
        <div class='c_body'><hr>
        <div class='leftblock'>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_sys\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>System information</a></p>
        <div id=block_sys style='display: none'>
        <table>
        <tr><td width=300>System Name:</td><td> $SYSNAME </td><tr>
        <tr><td>System version:</td><td>$SYSVERSION</td><tr>
        <tr><td>System platform:</td><td> $SYSPLATFORM </td><tr>
        <tr><td>System kernel version:</td><td> $KERNELVERSION </td><tr>
        <tr><td>System uptime:</td><td>$SYSTIME</td><tr>
        <tr><td>Number of users who still logged in:</td><td>${USERLOGIN}</td><tr>
        <tr><td>Number of running process:</td><td>$NUMOFRUNNINGPROC</td><tr>
        <tr><td>Load average of the system:</td><td>$LOADAVG</td></tr>
        </table></div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_cpu\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>CPU information:</a></p>
        <div id=block_cpu style='display: none'>
        <table>
       " >> ${HTMLFILE}
#CPU info
  if [ `uname` = "Linux" ];then
    echo "
          <tr><td width=300> $MODELNAME </td></tr>
          <tr><td> $FEATURES </td></tr>
          <tr><td> $CPUIMPLEMENTER </td></tr>
          <tr><td> $CPUARCH </td></tr>
          <tr><td> $CPUVAR </td></tr>
          <tr><td> $CPUPART </td></tr>
          <tr><td> $CPUREVISION </td></tr>
          <tr><td> $HW </td></tr>
          <tr><td> $REVEISIONREVEISION </td></tr>
          <tr><td> $SERIAL </td></tr>
         " >> ${HTMLFILE}
  elif [ `uname` = "FreeBSD" ];then
    echo "
          <tr><td width=300>Number of active CPUs:</td><td> $NUMOFCPU </td></tr>
          <tr><td>Machine model:</td><td> $MODEL </td></tr>
          <tr><td>System architecture:</td><td> $SYSARCH </td></tr>
          <tr><td>CPU current temperature:</td><td> $CPUTEMPERATURE </td></tr>
         " >> ${HTMLFILE}
  fi

  echo "
        </table>
        </div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_cpu_usage\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>CPU usage:</a></p>
        <div id=block_cpu_usage style='display: none'>
        <table>
        <tr><td width='100px'> $CPUUSAGE </td></tr>
        </table>
        </div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_disk_usage\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>Overall file system of disk usage:</a></p>
        <div id=block_disk_usage style='display: none'>
        <table>
        <tr><td width=130px> $FILESYS_HEAD </td></tr>
        <tr><td> $FILESYS_CONTENT </td></tr>
        </table>
        </div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_mem\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>Memory information:</a></p>
        <div id=block_mem style='display: none'>
        <table>
        <tr><td width=70px> $MEMORYINFO </td><tr>
        </table>
        </div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_swap\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>Swap usage:</a></p>
        <div id=block_swap style='display: none'>
        <table>
        <tr><td width=70px> $SWAPINFO </td><tr>
        </table>
        </div>
        <p><a style='text-decoration: none' href='javascript:extend(\"block_traffic\")'>
        <img height=9 src='img/plus.gif' width=9 border=0>Network traffic:</a></p>
        <div id=block_traffic style='display: none'>
        <table>
        <tr><td width=70px></td>
        <td align=center width=100px>rx</td><td align=center width=100px>tx</td>
        <td align=center width=100px>total</td></tr>
        <tr><td> $TRAFFIC_TODAY </td></tr>
        <tr><td> $TRAFFIC_MONTH </td></tr>
        </table>
        </div>
        </div>
        </div>
        </div>
        </body></html>
       " >> ${HTMLFILE}

