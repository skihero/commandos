#!/bin/bash

#
# Creates SNMPV3 user spiderman using superman 
# TODO: This needs a rewrite can't understand 
# a damn thing now 

creator="superman"
creator_secret="kryptonite" 
creator_super_secret="bruce_wayne"


follower="spiderman"
follower_secret="spidey_powers"
follower_super_secret="peter_parker"

SNMP_DIR="/etc/snmp"
CREATOR_FILE="creator.conf"
CREATOR_DIR="/tmp"

FINAL_FILE="final.conf"



for host in `cat hosts.txt`

do

	ssh -l root $host

	if [[ $? -ne 0 ]]; then 
	echo "Couldn't login"; 
	exit 1
	fi


	# Check if SNMP is installed 

	ls /etc/init.d/snmpd 

	if [[ $? -ne 0 ]]; then 
	echo -e "SNMP not installed \n RPMs available at 117 /var/cache/yum/*/* \n"; 
	exit 1
	fi


	# Generate creator and final conf
	
	cd $CREATOR_DIR

	echo"# Creator file 
	">>${CREATOR_DIR}/${CREATOR_FILE}


	# Generate final.conf
	echo"# Final file 
	">>${CREATOR_DIR}/${FINAL_FILE}



	# Stop running snmpd 
	/sbin/service snmpd stop 


	# Backup the snmpd.conf
	cp ${SNMP_DIR}/snmpd.conf ${SNMP_DIR}/snmpd.conf.bk


	# In the beginning

	cp ${CREATOR_DIR}/$CREATOR_FILE ${SNMP_DIR}/snmpd.conf

	if [[ $? -ne 0 ]]; then 
	echo "${CREATOR_DIR}/$CREATOR_FILE not found ";
	exit 1
	fi

	# Start SNMPD to create user
	/sbin/service snmpd start

	# Check if the creator is ready 
	# snmpwalk -v3 -u superman -n "" -l authNoPriv -a MD5 -A kryptonite localhost .0
	snmpwalk -v3 -u $creator -n "" -l authNoPriv -a MD5 -A $creator_secret localhost .0 

	if [[ $? -ne 0 ]]; then 
	echo "Too much Kryptonite";
	exit 1
	fi

	# Create follower 
	snmpusm -v3 -u $creator -n "" -l authNoPriv -a MD5 -A $creator_secret localhost create $follower $creator


	if [[ $? -ne 0 ]]; then 
	echo "Not following "; 
	exit 1
	fi

	# Give secret to follower

	snmpusm -v3 -u $follower -n "" -l authNoPriv -a MD5 -A $creator_secret -x DES -X $follower_super_secret localhost passwd $creator_secret $follower_secret ;
	
	if [[ $? -ne 0 ]]; then 
	echo "Secret not set "; 
	exit 1
	fi

	# Check follower
	snmpget -v 3 -u $follower -n "" -l authNoPriv -a MD5 -A $follower_secret localhost sysUpTime.0


	if [[ $? -ne 0 ]]; then 
	echo "Follower verified"; 
	exit 1
	fi




	# Stop running snmpd 
	/sbin/service snmpd stop 

	if [[ $? -ne 0 ]]; then 
	echo "Cannot stop snmp to write final snmp"; 
	exit 1
	fi

	cp ${CREATOR_DIR}/$FINAL_FILE ${SNMP_DIR}/snmpd.conf
	if [[ $? -ne 0 ]]; then 
	echo "Final file written"; 
	exit 1
	fi
	

	/sbin/service snmpd start
	if [[ $? -ne 0 ]]; then 
	echo "Cannot restart SNMP after writing final file"; 
	exit 1
	fi


	echo "Final file written $follower v3 created "


done 


echo "Done check for traps "

exit 0 




 


