#!/bin/bash
# Author: Jeongseob Ahn (ahnjeong@umich.edu)

# Permission check
if [ $(id -u) != 0 ]
then
	echo "To lockdown the L2 ways, you need the root permission"
	exit 1
fi

if [ "$#" -ne 1 ]
then
	echo "Usage:$0 [way(1~15, 16: unlock)]"
	exit 1
fi

WAY=$1
BASE_VALUE=0x8000400000800220
MSR_ADDR=0xc0011023

# Check if msr-tools has been installed
./check-msr.sh

if [ "$WAY" -ge 1 -a "$WAY" -lt 16 ];
then
	echo "The ways from $WAY to 15 are locked"
	value=$(($BASE_VALUE|($WAY<<19)))
	printf "wrmsr -a $MSR_ADDR 0x%x\n" $value
	cmd=$(printf "wrmsr -a $MSR_ADDR 0x%x\n" $value)
	`$cmd`

elif [ "$WAY" -eq "16" ]
then
	echo "L2 way lock disabled"
	wrmsr -a $MSR_ADDR 0x8000400000000220
else
	echo "The range is from 1 to 16"
	exit 1
fi
