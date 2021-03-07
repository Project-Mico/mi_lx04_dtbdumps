#########################################################################
# File Name: autoloop.sh
# Author: xulongqiu
# mail: xulongqiu@xiaomi.com
# Created Time: 2018-07-09 16:59:12
#########################################################################
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "$0 playfile recordfile"
    exit 0
fi

if ! [ -f $1 ]; then
    echo "file $1 does't exist"
    exit 0
fi

seconds=10
if [ $# -eq 3 ]; then
    seconds=$3
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

MiPlayerDemo $1 &
MiRecordDemo -o $2 -b -r 16000 -c 3 &
sleep $seconds
killall -s 2 MiPlayerDemo
killall -s 2 MiRecordDemo
