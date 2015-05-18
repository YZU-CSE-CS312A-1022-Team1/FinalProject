#!/bin/bash

export PATH="~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

cd `dirname "$0"`
./index.sh
./networkTraffic.sh
./userSumUp.sh
./collectAccount.sh
