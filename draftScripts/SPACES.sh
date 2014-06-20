#!/bin/bash
#Promgram : space rank

TEMP="$(mktemp RankSpaceResult.XXXXXXX)"
users=$(last | awk '{if (( NF >= 10 ) && ($1 != "reboot")) print $1}'| sort | uniq) #username

for username in $users
do
    USER=$username
    HOME=`eval echo ~${USER}`

    if [ -d  /${HOME} ]; then  #判斷Path是否存在
        SPACES=`du -s /${HOME}`
        echo -e "${SPACES} $username" >> $TEMP
    fi
done

RANK=`awk '{if(($3 != NULL)&&($1 != NULL))print $1 "\t" $3}' $TEMP | sort -n -r | \
      awk '{if($1 > 1024) {print $1/1024" Mbyte\t" $2 } else {print $1" Kbyte\t"$2 }}' | \
      awk '{if($1 > 1024) {print $1/1024" Gbyte\t" $3 } else {print }}'`
echo -e "Ranked space of all users : \n${RANK}"
rm $TEMP
exit 0