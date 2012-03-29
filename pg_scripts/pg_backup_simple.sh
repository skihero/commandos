#!/bin/bash


WHICH="`which which`"
DT="`date +"%Y_%m_%d_%H_%M"`"


DUMP=`which pg_dump` 

BACKUP_DIR="/pg_backup"
USER="postgres" 

MAIL="kishore.k@domain.com" 
HOST=`hostname`
LOGFILE="${BACKUP_DIR}/pg_sql_bkp_${DT}.log" 

touch ${LOGFILE}
exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.

exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.

exec > ${LOGFILE}     # stdout and err replaced with file ${LOGFILE}.
exec 2>  ${LOGFILE}   


# Do the actual dump 
echo "Starting backups `date` " 
${DUMP} -U${USER} -F t -f ${BACKUP_DIR}/"db_name_"${DT} "db_name" 
user_ret=$?
 

size=`du -h ${BACKUP_DIR}`

echo "Deleting 10 day old files ..."
find ${BACKUP_DIR}/ -mtime +10 -exec rm -vf {} \; 

echo -e "User: $user_ret \nsize: ${size} "  

echo "Done backups `date` " 
cat ${LOGFILE} | mail -s "PgSQL log for ${HOST} - ${DT}" ${MAIL} 


#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.

