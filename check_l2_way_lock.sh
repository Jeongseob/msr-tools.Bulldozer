#!/bin/bash

# Permission check
if [ $(id -u) != 0 ]
then
  echo "Root permission is required to run this script!"
  exit 1
fi

# Check if msr-tools has been installed
./check_msr.sh

# Get the register value
check=`rdmsr 0xc0011023 -f 23:23`

# Print out the result
if [ "$check" == "1" ]
then
  echo "L2 way lock is enabled."
else
  echo "L2 way lock is disabled."
fi
