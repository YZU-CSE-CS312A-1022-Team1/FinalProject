#! /bin/sh

if [ `uname` = "FreeBSD" ];then
    ECHO="echo"
else
    ECHO="/bin/echo"
fi

if [ -x system.sh ] && [ -x AllUserInfo.sh ] && [ -x EachUserInfo.sh ];then
    ${ECHO} -e "Run System.sh\n"
    ./system.sh
    ${ECHO} -e "\nRun EachUserInfo.sh\n"
    ./EachUserInfo.sh
    ${ECHO} -e "\nRun AllUserInfo.sh\n"
    ./AllUserInfo.sh
else
    "File not exist."
fi
