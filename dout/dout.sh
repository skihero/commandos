#!/bin/bash 

#set -x

# Usage 
if [ $# -lt 2 ];
then 
   echo "Usage: $0 domain host_pat1 .. host_patn" 
   exit 2 
fi 

# Read the domain names 
DOMAIN="$1"

# Shift param 
shift 

# Read the host pattern 
HOST_PAT="$@"

# Set the range(No. of machines)
RANGE=10 

# Save File 
SAVE_FILE="/tmp/dig_out${RANDOM}"

# Generated hosts
GEN_HOSTS="/tmp/gen_host${RANDOM}"

for HOST in "$@" 
do 
   for r in `seq 1 $RANGE` 	
	do 
	MACHINE="${HOST}${r}.${DOMAIN}.com"
	echo ${MACHINE} >> ${GEN_HOSTS}
	done 
done 

echo "Generated hosts list..."
echo "Digging hosts from ${GEN_HOSTS} ..." 
dig +nocmd -f ${GEN_HOSTS} +noall +answer >> ${SAVE_FILE}

echo "Digs saved at ${SAVE_FILE}"


#Should be done 

 
