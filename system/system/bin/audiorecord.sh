#########################################################################
# File Name: audiorecord.sh
# Author: xulongqiu
# mail: xulongqiu@xiaomi.com
# Created Time: 2018-07-09 16:59:12
#########################################################################
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0 recordfile"
    exit 0
fi
loopback=`getprop config.mi.audio.aec.loopback`
if ! [ $loopback = "0" ]; then
    setprop config.mi.audio.aec.loopback 0
    loopback=`getprop config.mi.audio.aec.loopback`
    if ! [ $loopback = "0" ]; then
        echo "set extern adc as AEC error"
        exit 0
    fi
fi

MiRecordDemo -o $1 -b -r 16000 -c 3

