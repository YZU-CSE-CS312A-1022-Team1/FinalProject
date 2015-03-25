#!/bin/bash
DIR="results"
HTMLFILE="networkTraffic.html"
mkdir -p $DIR && cd $DIR

if [ -e $HTMLFILE ];then
  rm -f $HTMLFILE
fi

#put all username in an arrary
ALLUSER=`last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq`
USERLIST=($ALLUSER)

MONTH=`date +"%m"`
DAYOFMONTH=`date +"%d"`
TRAFFIC=`vnstat -d | grep ${MONTH}/ | awk '{if($3 == "KiB"){ print $1" "$2/1024" "$5" "$6" "$8" "$9" "$11} \
         else{print $1" "$2" "$5" "$6" "$8" "$9" "$11}}' | awk '{if($4=="KiB"){print $1" "$2" "$3/1024" "$5" "$6" "$7} \
         else{print $1" "$2" "$3" "$5" "$6" "$7}}' | awk '{if($5=="KiB"){print $1" "$2" "$3" "$4/1024" "$6} \
         else{print $1" "$2" "$3" "$4" "$6}}'`

DATE=`echo $(echo -e "${TRAFFIC}" | awk 'BEGIN {FS="/"} {print $1"/"$2}')`
RX=`echo $(echo -e "${TRAFFIC}" | awk '{printf("%6s\n", $2)}')`
TX=`echo $(echo -e "${TRAFFIC}" | awk '{printf("%6s\n", $3)}')`
TOTAL=`echo $(echo -e "${TRAFFIC}" | awk '{printf("%6s\n",$4)}')`
RATE=`echo $(echo -e "${TRAFFIC}" | awk '{printf("%6s\n",$5)}')`

DATELIST=($DATE)
RXLIST=($RX)
TXLIST=($TX)
TOTALLIST=($TOTAL)
RATELIST=($RATE)

if [ -e $HTMLFILE ]; then
  rm $HTMLFILE
fi

echo "<html><head><meta http-equiv='content-Type' content='text/html; charset=UTF-8' />
      <title>`hostname` - User behavior analysis</title>
      <link rel='stylesheet' media='screen,print' href='css/layout.css' />
      <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
      <script type='text/javascript' src='//cdnjs.cloudflare.com/ajax/libs/highcharts/4.1.4/highcharts.js'></script>
      <script type='text/javascript' src='js/networkTraffic.js'></script>
      <script type='text/javascript' src='js/userList.js'></script>
      <script type='text/javascript' src='userList.json'></script>
      <script language=javascript>
     " >> ${HTMLFILE}
echo "var username = JSON.parse(userlist);" >> ${HTMLFILE}
echo -n "var date=[" >> ${HTMLFILE}
for (( i=0; i<${#DATELIST[@]}; i++ )); do
  if [ $i != $((${#DATELIST[@]} -1)) ]; then
    echo -n "\"${DATELIST[$i]}\"," >> ${HTMLFILE}
  else
    echo -n "\"${DATELIST[$i]}\"" >> ${HTMLFILE}
  fi
done
echo "];" >> ${HTMLFILE}

echo -n "var rx=[" >> ${HTMLFILE}
for (( i=0; i<${#RXLIST[@]}; i++ )); do
  if [ $i != $((${#RXLIST[@]} -1)) ]; then
    echo -n "${RXLIST[$i]}," >> ${HTMLFILE}
  else
    echo -n "${RXLIST[$i]}" >> ${HTMLFILE}
  fi
done
echo "];" >> ${HTMLFILE}

echo -n "var tx=[" >> ${HTMLFILE}
for (( i=0; i<${#TXLIST[@]}; i++ )); do
  if [ $i != $((${#TXLIST[@]} -1)) ]; then
    echo -n "${TXLIST[$i]}," >> ${HTMLFILE}
  else
    echo -n "${TXLIST[$i]}" >> ${HTMLFILE}
  fi
done
echo "];" >> ${HTMLFILE}

echo -n "var total=[" >> ${HTMLFILE}
for (( i=0; i<${#TOTALLIST[@]}; i++ )); do
  if [ $i != $((${#TOTALLIST[@]} -1)) ]; then
    echo -n "${TOTALLIST[$i]}," >> ${HTMLFILE}
  else
    echo -n "${TOTALLIST[$i]}" >> ${HTMLFILE}
  fi
done
echo "];" >> ${HTMLFILE}

echo -n "var rate=[" >> ${HTMLFILE}
for (( i=0; i<${#RATELIST[@]}; i++ )); do
  if [ $i != $((${#RATELIST[@]} -1)) ]; then
    echo -n "${RATELIST[$i]}," >> ${HTMLFILE}
  else
    echo -n "${RATELIST[$i]}" >> ${HTMLFILE}
  fi
done
echo "];" >> ${HTMLFILE}

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
        <h1>Network Traffic</h1></div>
        <div class='c_body'><hr>
        <div class='leftblock'>
        <table><tr><td colspan=2><h2>Daily Upload / Download flow</h2></td></tr>
        <tr><td>
        <div id='txrx_chart' style='width: 800px; height: 400px; margin: 0 0 0 0px'></div>
        </td></tr>
        </table>
        <table><tr><td colspan=2><h2>Daily total flow</h2></td></tr>
        <tr><td>
        <div id='total_chart' style='width: 800px; height: 400px; margin: 0 0 0 0px'></div>
        </td></tr>
        </table>
        <table><tr><td colspan=2><h2>Average rate</h2></td></tr>
        <tr><td>
        <div id='rate_chart' style='width: 800px; height: 400px; margin: 0 0 0 0px'></div>
        </td></tr>
        </table>
        </div>
        </div>
        </div>
        </body></html>
       "  >> ${HTMLFILE}
