set_cpu_env()
{
    if [ $# -ne 3 ]; then
        echo "Usage $0 freqMax, freqMin, governor"
        return
    fi     
    
    echo $3 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo $1 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
    echo $2 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    
    #wait for setting valid
    for i in 0 1 2; do
        freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
        governor=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
        freqMax=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
        freqMin=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
        echo "freq=$freq, freqMax=$freqMax, freqMin=$freqMin, governor=$governor"
        if [ $freq -le $2 ] && [ $freq -ge $1 ]  && [ $governor == $3 ] && [ $freqMax -eq $2 ] && [ $freqMin -eq $1 ]; then
            echo "set_cpu_env:succfully"
            break
        else
            sleep 1
        fi
    done
    if [ $i -eq 2 ]; then
       echo "set_cpu_env:fail"
       echo "frequenceies:" [`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`]
       echo "governors   :" [`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`]
    fi
}

if [ $# -ne 3 ]; then
    echo "$0 maxFreq minFreq governor"
    echo "frequenceies:" [`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`]
    echo "governors   :" [`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`]
    echo "freqMax=" `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
    echo "freqMin=" `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
    exit 0
fi

echo '1. disable thermal'
thermal_manager /vendor/etc/.tp/.ht120.mtc
ret=`cat /data/.tp/.settings`
if [ "xx$ret" = "xx/vendor/etc/.tp/.ht120.mtc" ]; then
    echo "disable thermal succ"
fi

echo '2. disable HPS'
echo 0 > /proc/hps/enabled
ret=`cat /proc/hps/enabled`
if [ "xx$ret" = "xx0" ]; then
    echo "disable hps succ"
fi

echo "3. open all cores"
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
ret=`cat /sys/devices/system/cpu/online`
if [ "xx$ret" = "xx0-3" ]; then
    echo "open all cores succ"
fi

echo "4. set_cpu_env: freqs: $1 ~ $2, governor: $3"
set_cpu_env $1 $2 $3

echo "online cores: " `cat /sys/devices/system/cpu/online`
echo "now freq: " `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
