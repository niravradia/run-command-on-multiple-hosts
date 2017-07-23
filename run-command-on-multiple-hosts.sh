#!/bin/bash

# Parse parameters
while [ $# -gt 0 ]
do
key="$1"

case $key in
    --hosts)
    hosts=$2
    shift
    ;;
esac
shift
done

# Verify Hosts are entered, exit otherwise
if [ -z "${hosts}" ] ; then
   echo "Script failed : The mandatory param --hosts is missing.". 
   exit 1;
fi

# prepare an array of Hosts to loop
IFS=',' read -r -a hosts_array <<< "$hosts"

# Read a single command to run on all the hosts
read -p "Command to execute:" command

# Verify command is entered
if [ -z "${command}" ] ; then
   echo "Script failed : The command is not entered".
   exit 1;
fi

# Loop through hosts and run command via ssh. It is assumed that username is same as current machine and key is not required
# StrictHostKeyChecking and some other ssh settings are passed to optimize the command
for host in "${hosts_array[@]}"
do
    echo "Running comand on $host"
    ssh -o TCPKeepAlive=yes -o ServerAliveInterval=30 -o StrictHostKeyChecking=no $host $command
	
	#Use below command if key and username are required
	#ssh -o TCPKeepAlive=yes -o ServerAliveInterval=30 -o StrictHostKeyChecking=no -i key.ppk ubuntu@$host $command
done
