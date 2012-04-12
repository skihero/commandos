#!/bin/bash
# God I like to send mails 
# This script backus up a directory and
# Sends a mail with the log 


#set -x 

YEST=$(/bin/date -d '1 day ago' +"%d_%m_%Y")

MAIL="kishore.k@ "
HOST="`/bin/hostname`"
DT="`date +"%Y_%m_%d_%H_%M"`"

DATA_DIR="/opt/post_data/_listener" 

LOGFILE="${DATA_DIR}/archive_log.tmp" 

LOCK="${DATA_DIR}/archive.lock" 

touch ${LOGFILE}

exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.

exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.

exec > ${LOGFILE}     # stdout replaced with file ${LOGFILE}.
exec 2>  ${LOGFILE}   

echo "Backup Started at `date` for ${YEST}"

if [ ! -f ${LOCK} ]; then 

	touch ${LOCK} 
	 
	/bin/tar cjf ${DATA_DIR}/${YEST}.tar.bz2 ${DATA_DIR}/${YEST} > /dev/null 2>&1
	lines=$(/bin/tar tjf ${DATA_DIR}/${YEST}.tar.bz2 | /usr/bin/wc -l)

	if [ $lines -gt 0 ]; then
		echo "Tar generated successfully. Deleting original files..." 
		rm -rf ${DATA_DIR}/${YEST}
	else 
		echo "Tar not generated properly or no files. Not deleting anything"
	fi 
else 
	echo "Earlier run in progress or failed miserably " 
fi 

echo "Backup Completed at `date` for ${YEST}" 


/bin/cat ${LOGFILE} | /bin/mail -s "  archive for ${HOST} - ${DT}" ${MAIL} -- -f "notifications@ o"


[ -f ${LOCK} ] && rm -f ${LOCK}  ## run the script twice to reset

#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.




# Fin 

