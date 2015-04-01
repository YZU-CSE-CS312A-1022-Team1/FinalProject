#!/bin/bash

HTMLFILE="dailyTraffic.html"

if [ -e $HTMLFILE ]; then
  rm $HTMLFILE
fi

DumpDB=`vnstat --dumpdb | awk 'BEGIN {FS=";"}{if($1=="d"||$1=="m"||$1=="t"||$1=="h"){print}}'`

Daily=`vnstat -d | awk '{if(NF==12){print}}'`
Daily_Count=`echo -e "$(echo -e "${Daily}" | wc -l)"`
Daily_Date=(`echo -e "$(echo -e "${Daily}" | awk '{print $1}')"`)
Daily_Rx=(`echo -e "$(echo -e "${Daily}" | awk '{print $2}')"`)
Daily_Rx_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $3}')"`)
Daily_Tx=(`echo -e "$(echo -e "${Daily}" | awk '{print $5}')"`)
Daily_Tx_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $6}')"`)
Daily_Total=(`echo -e "$(echo -e "${Daily}" | awk '{print $8}')"`)
Daily_Total_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $9}')"`)
Daily_Estimated=(`echo -e "$(vnstat -d | tail -1 | awk '{print $1" "$2" "$3" "$5" "$6" "$8" "$9}')"`)

barChart_Daily_Rx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="d"&&$3!="0"){print $4}}')"`)
barChart_Daily_Tx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="d"&&$3!="0"){print $5}}')"`)

Day=( "Daily_Date" "Daily_Rx" "Daily_Rx_Unit"  "Daily_Tx" "Daily_Tx_Unit" "Daily_Total" "Daily_Total_Unit")
Daily_List=( "${Daily_Date[@]}" "${Daily_Rx[@]}" "${Daily_Rx_Unit[@]}"  "${Daily_Tx[@]}" "${Daily_Tx_Unit[@]}" \
             "${Daily_Total[@]}" "${Daily_Total_Unit[@]}")
count=0
index=0

echo "<!DOCTYPE html>
      <html>
      <head>
      <title>DrawDailyTraffic</title>
      <script>
     " >> ${HTMLFILE}

for (( i=0; i<${#Daily_List[@]}; i++ )); do
  if [ ${count} == 0 ]; then
    echo -n "var ${Day[$index]}=[ " >> ${HTMLFILE}
  fi
  count=$(($count+1))
  if [ $(($index%2)) == 0 ]; then
    echo -n "\"${Daily_List[$i]}\"" >> ${HTMLFILE}
  else
    echo -n "${Daily_List[$i]}" >> ${HTMLFILE}
  fi
  if [ ${count} == ${Daily_Count} ]; then
    echo " ];" >> ${HTMLFILE}
    count=0
    index=$(($index+1))
  else
    echo -n ", " >> ${HTMLFILE}
  fi
done

echo -n "var Daily_Estimated='[ " >> ${HTMLFILE}
for (( i=0; i<${#Daily_Estimated[@]}; i++));do
  echo -n "\"${Daily_Estimated[$i]}\"" >> ${HTMLFILE}
  if [ ${i} == $((${#Daily_Estimated[@]}-1)) ]; then
    echo " ]';" >> ${HTMLFILE}
  else
    echo -n ", " >> ${HTMLFILE}
  fi
done

Bar=( "barChart_Daily_Rx" "barChart_Daily_Tx")
Bar_List=( "${barChart_Daily_Rx[@]}" "${barChart_Daily_Tx[@]}")

count=0
index=0

for (( i=0; i<${#Bar_List[@]}; i++ )); do
  if [ ${count} == 0 ]; then
    echo -n "var ${Bar[$index]}=[ " >> ${HTMLFILE}
  fi
  count=$(($count+1))
  echo -n "${Bar_List[$i]}" >> ${HTMLFILE}
  if [ ${count} == ${Daily_Count} ]; then
    echo " ];" >> ${HTMLFILE}
    count=0
    index=$(($index+1))
  else
    echo -n ", " >> ${HTMLFILE}
  fi
done

echo "</script>
      <script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js'></script>
      <script type='text/javascript' src='http://cdnjs.cloudflare.com/ajax/libs/highcharts/4.1.4/highcharts.js'></script>
      <script type='text/javascript' src='js/dailyTraffic.js'></script>
      </head>
      <body>
      <table>
      <colgroup><col span='4'></col></colgroup>
      <colgroup><col></col></colgroup>
      <tr>
      <th>day</th>
      <th>rx</th>
      <th>tx</th>
      <th>total</th>
      <td rowspan='$((${Daily_Count}+1))'>
      <div id='Daily' style='min-width: 310px; max-width: 300px; height:1000px; margin: 0 auto'></div>
      </td>
      </tr>
      " >> ${HTMLFILE}

for (( i=0; i<${Daily_Count}; i++));do
  echo "
        <tr>
        <td>${Daily_Date[$i]}</td>
        <td>${Daily_Rx[$i]} ${Daily_Rx_Unit[$i]}</td>
        <td>${Daily_Tx[$i]} ${Daily_Tx_Unit[$i]}</td>
        <td>${Daily_Total[$i]} ${Daily_Total_Unit[$i]}</td>
        </tr>
       " >> ${HTMLFILE}
done

echo "<tr>
      <td>estimated</td><td>${Daily_Estimated[1]} ${Daily_Estimated[2]}</td><td>${Daily_Estimated[3]} ${Daily_Estimated[4]}</td><td>${Daily_Estimated[5]} ${Daily_Estimated[6]}</td>
      </tr>
      </table>
      </body>
      </html>
      " >> ${HTMLFILE}



