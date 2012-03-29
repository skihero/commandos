#!/bin/bash
# This file is managed by puppet 
#
# Changes here will be overwritten 
# Cron to keep in sync with the svn codebase 
# 
# Fetches the SVN location specified  
# Update the local copy if the dest dir already present
#
# Logs error only 
#

set -x 

DT="`date +"%Y_%m_%d_%H_%M"`"
MAIL_LIST="kishore.kumar@company.com" 

# Remote Location 
# TODO: Make this a param. 

RM_LOC="http://company.svn/infrastructure/puppet/environments/staging/modules/apps/files/startup"

# Local Location 
LC_LOC="/etc/puppet/environments/staging/remote_files"


# SVN binary 
SVN_BIN=`which svn`


# SVN options 
SVN_OPTS=" checkout " 

# Extra options 
EXTRA_OPTS=" --non-interactive "

# UNAME 
UNAME=" "

# TODO: Get a user for this 
# PASSWORD 
PASSWORD="" 

# Log file 
LOG_FILE="/opt/scripts/log/cron/svn_sync.log" 
touch ${LOG_FILE}

echo "Hi" > ${LOG_FILE}  # Reset the log file 

exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.

exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.

exec > ${LOG_FILE}     # stdout replaced with file ${LOGFILE}.
exec 2>  ${LOG_FILE}   

# Do an update if already checked out 
if [ -d ${LC_LOC} ]; then 
	SVN_OPTS=" update " 
fi 

# Try syncing and log errors 
$SVN_BIN  $SVN_OPTS  $EXTRA_OPTS $RM_LOC  $LC_LOC 

if [ $? -ne 0 ]; then 
	# Should probably send mail here 
	echo "Cronjob failed $0 " | mail -s "CronJob fail at `hostname` at `date` " $MAIL_LIST


	#Clean up IO redirection
	exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
	exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.
	exit 1 
fi 

#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.

exit 0 	

