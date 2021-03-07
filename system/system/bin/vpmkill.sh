#########################################################################
# File Name: vpm_test.sh
# Author: xulongqiu
# mail: xulongqiu@xiaomi.com
# Created Time: 2018-09-17 19:16:45
#########################################################################
#!/bin/bash


ps -A|grep MiVpmClient|cut -d ' ' -f 8,9,10,11,12|xargs kill -9


