#!/bin/bash

JSONFile="vnstatData.json"

if [ -e ${JSONFile} ]; then
    rm ${JSONFile}
fi

#To equally draw the bar chart, dumping the data from the database with same unit
#the number of daily data is up to 30. (0~29)

DumpDB=`vnstat --dumpdb | awk 'BEGIN {FS=";"}{if($1=="d"||$1=="m"||$1=="t"||$1=="h"){print}}'`

barChart_Daily_Rx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="d"&&$3!="0"){print $4}}')"`)
barChart_Daily_Tx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="d"&&$3!="0"){print $5}}')"`)
barChart_Monthly_Rx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="m"&&$3!="0"){print $4}}')"`)
barChart_Monthly_Tx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="m"&&$3!="0"){print $5}}')"`)
barChart_Hourly_Rx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="h"){print $4}}')"`)
barChart_Hourly_Tx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="h"){print $5}}')"`)
barChart_Top10_Rx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="t"&&$3!="0"){print $4}}')"`)
barChart_Top10_Tx=(`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="t"&&$3!="0"){print $5}}')"`)

#=======================================
#the number of daily data is up to 30. (0~29)
Daily=`vnstat -d | awk '{if(NF==12){print}}'`
Daily_Count=`echo -e "$(echo -e "${Daily}" | wc -l)"`

Daily_Date=(`echo -e "$(echo -e "${Daily}" | awk '{print $1}')"`)
Daily_Rx=(`echo -e "$(echo -e "${Daily}" | awk '{print $2}')"`)
Daily_Rx_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $3}')"`)
Daily_Tx=(`echo -e "$(echo -e "${Daily}" | awk '{print $5}')"`)
Daily_Tx_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $6}')"`)
Daily_Total=(`echo -e "$(echo -e "${Daily}" | awk '{print $8}')"`)
Daily_Total_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $9}')"`)
Daily_Avg=(`echo -e "$(echo -e "${Daily}" | awk '{print $11}')"`)
Daily_Avg_Unit=(`echo -e "$(echo -e "${Daily}" | awk '{print $12}')"`)

#========================================
#the number of monthly data is up to 12. (0~11)
Monthly=`vnstat -m | awk '{if(NF==13){print }}'`
Monthly_Count=`echo -e "$(echo -e "${Monthly}" | wc -l)"`

Monthly_Month=(`echo -e "$(echo -e "${Monthly}" | awk '{print $1 $2}')"`)
Monthly_Rx=(`echo -e "$(echo -e "${Monthly}" | awk '{print $3}')"`)
Monthly_Rx_Unit=(`echo -e "$(echo -e "${Monthly}" | awk '{print $4}')"`)
Monthly_Tx=(`echo -e "$(echo -e "${Monthly}" | awk '{print $6}')"`)
Monthly_Tx_Unit=(`echo -e "$(echo -e "${Monthly}" | awk '{print $7}')"`)
Monthly_Total=(`echo -e "$(echo -e "${Monthly}" | awk '{print $9}')"`)
Monthly_Total_Unit=(`echo -e "$(echo -e "${Monthly}" | awk '{print $10}')"`)
Monthly_Avg=(`echo -e "$(echo -e "${Monthly}" | awk '{print $12}')"`)
Monthly_Avg_Unit=(`echo -e "$(echo -e "${Monthly}" | awk '{print $13}')"`)

#========================================

Top10=`vnstat -t | awk '{if(NF==13){print}}'`
Top10_Count=`echo -e "$(echo -e "${Top10}" | wc -l )"`

Top10_Date=(`echo -e "$(echo -e "${Top10}" | awk '{print $2}')"`)
Top10_Rx=(`echo -e "$(echo -e "${Top10}" | awk '{print $3}')"`)
Top10_Rx_Unit=(`echo -e "$(echo -e "${Top10}" | awk '{print $4}')"`)
Top10_Tx=(`echo -e "$(echo -e "${Top10}" | awk '{print $6}')"`)
Top10_Tx_Unit=(`echo -e "$(echo -e "${Top10}" | awk '{print $7}')"`)
Top10_Total=(`echo -e "$(echo -e "${Top10}" | awk '{print $9}')"`)
Top10_Total_Unit=(`echo -e "$(echo -e "${Top10}" | awk '{print $10}')"`)
Top10_Avg=(`echo -e "$(echo -e "${Top10}" | awk '{print $12}')"`)
Top10_Avg_Unit=(`echo -e "$(echo -e "${Top10}" | awk '{print $13}')"`)

#=========================================
#the number of Hourly data is up to 24. (0~23)

Hour_Rx=`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="h"){print $4}}')"`
Hour_Tx=`echo -e "$(echo -e "${DumpDB}" | awk 'BEGIN {FS=";"}{if($1=="h"){print $5}}')"`

#======================================
Weekly=`vnstat -w | awk '{if(NF>10){print}}'`


#============================================================

Bar=( "barChart_Daily_Rx" "barChart_Daily_Tx" "barChart_Monthly_Rx" "barChart_Monthly_Tx" "barChart_Hourly_Rx" "barChart_Hourly_Tx" "barChart_Top10_Rx" "barChart_Top10_Tx" )
Bar_List=( "${barChart_Daily_Rx[@]}" "${barChart_Daily_Tx[@]}" "${barChart_Monthly_Rx[@]}" "${barChart_Monthly_Tx[@]}" \
           "${barChart_Hourly_Rx[@]}" "${barChart_Hourly_Tx[@]}" "${barChart_Top10_Rx[@]}" "${barChart_Top10_Tx[@]}" )
bar_Count=( ${Daily_Count}  ${Daily_Count} ${Monthly_Count} ${Monthly_Count} 24 24 10 10 )

count=0
index=0

for (( i=0; i<${#Bar_List[@]}; i++ )); do
    if [ ${count} == 0 ]; then
        echo -n "var ${Bar[$index]}='[ " >> ${JSONFile}
    fi
    count=$(($count+1))

    echo -n "${Bar_List[$i]}" >> ${JSONFile}

    if [ ${count} == ${bar_Count[${index}]} ]; then
        echo " ]';" >> ${JSONFile}
        count=0
        index=$(($index+1))
    else
        echo -n ", " >> ${JSONFile}
    fi
done

Day=( "Daily_Date" "Daily_Rx" "Daily_Rx_Unit"  "Daily_Tx" "Daily_Tx_Unit" "Daily_Total" "Daily_Total_Unit" "Daily_Avg" "Daily_Avg_Unit" )
Daily_List=( "${Daily_Date[@]}" "${Daily_Rx[@]}" "${Daily_Rx_Unit[@]}"  "${Daily_Tx[@]}" "${Daily_Tx_Unit[@]}" \
             "${Daily_Total[@]}" "${Daily_Total_Unit[@]}" "${Daily_Avg[@]}" "${Daily_Avg_Unit[@]}" )
count=0
index=0

for (( i=0; i<${#Daily_List[@]}; i++ )); do

    if [ ${count} == 0 ]; then
        echo -n "var ${Day[$index]}='[ " >> ${JSONFile}
    fi

    count=$(($count+1))

    if [ $(($index%2)) == 0 ]; then
        echo -n "\"${Daily_List[$i]}\"" >> ${JSONFile}
    else
        echo -n "${Daily_List[$i]}" >> ${JSONFile}
    fi

    if [ ${count} == ${Daily_Count} ]; then
        echo " ]';" >> ${JSONFile}
        count=0
        index=$(($index+1))
    else
        echo -n ", " >> ${JSONFile}
    fi

done

Month=( "Monthly_Month" "Monthly_Rx" "Monthly_Rx_Unit"  "Monthly_Tx" "Monthly_Tx_Unit" "Monthly_Total" "Monthly_Total_Unit" "Monthly_Avg" "Monthly_Avg_Unit" )
Monthly_List=( "${Monthly_Month[@]}" "${Monthly_Rx[@]}" "${Monthly_Rx_Unit[@]}"  "${Monthly_Tx[@]}" "${Monthly_Tx_Unit[@]}" \
               "${Monthly_Total[@]}" "${Monthly_Total_Unit[@]}" "${Monthly_Avg[@]}" "${Monthly_Avg_Unit[@]}" )
count=0
index=0

for (( i=0; i<${#Monthly_List[@]}; i++ )); do
    if [ ${count} == 0 ]; then
        echo -n "var ${Month[$index]}='[ " >> ${JSONFile}
    fi

    count=$(($count+1))

    if [ $(($index%2)) == 0 ]; then
        echo -n "\"${Monthly_List[$i]}\"" >> ${JSONFile}
    else
        echo -n "${Monthly_List[$i]}" >> ${JSONFile}
    fi

    if [ ${count} == ${Monthly_Count} ]; then
        echo " ]';" >> ${JSONFile}
        count=0
        index=$(($index+1))
    else
        echo -n ", " >> ${JSONFile}
    fi
done

TOP10=( "Top10_Date" "Top10_Rx" "Top10_Rx_Unit"  "Top10_Tx" "Top10_Tx_Unit" "Top10_Total" "Top10_Total_Unit" "Top10_Avg" "Top10_Avg_Unit" )
Top10_List=( "${Top10_Date[@]}" "${Top10_Rx[@]}" "${Top10_Rx_Unit[@]}"  "${Top10_Tx[@]}" "${Top10_Tx_Unit[@]}" \
             "${Top10_Total[@]}" "${Top10_Total_Unit[@]}" "${Top10_Avg[@]}" "${Top10_Avg_Unit[@]}" )
count=0
index=0

for (( i=0; i<${#Top10_List[@]}; i++ )); do
    if [ ${count} == 0 ]; then
        echo -n "var ${TOP10[$index]}='[ " >> ${JSONFile}
    fi

    count=$(($count+1))

    if [ $(($index%2)) == 0 ]; then
        echo -n "\"${Top10_List[$i]}\"" >> ${JSONFile}
    else
        echo -n "${Top10_List[$i]}" >> ${JSONFile}
    fi

    if [ ${count} == ${Top10_Count} ]; then
        echo " ]';" >> ${JSONFile}
        count=0
        index=$(($index+1))
    else
        echo -n ", " >> ${JSONFile}
    fi
done
