while [ 1 ];
do
    freqMax=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
    freqMin=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
    freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
    governor=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
    num=`cat /sys/devices/system/cpu/online`
    cTemp=`cat /sys/class/thermal/thermal_zone1/temp`
    sTemp=`cat /sys/class/thermal/thermal_zone3/temp`
    echo "freq=$freq($freqMax/$freqMin), oneline=$num, temp=$cTemp/$sTemp, governor=$governor"
    sleep 1
done
