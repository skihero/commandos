#!/bin/bash 
#
# Read the war and produce rpm
#
#

#set -x 

#
# Usage 
#  
usage(){
	echo "Usage: $0 appname tomcat_full version release destination_path"
        echo "./build_tomcat_app.sh  tomcat-ctadmin-1 tomcat-ctadmin-1 1 0  /usr/local/release3" 
	echo "./build_tomcat_full_versions.sh \${app}-rel1  /root/all_configs/tomcat-configs/release1/${app}/ 1 0 /usr/local/release1 "  
	echo " ---------------------------------------------^ Need the full path " 

	exit 1
}
# 
# Usage 
#  ./build_tomcat_app.sh  tomcat-ctadmin-1 tomcat-ctadmin-1 1 0  /usr/local/release3
# 
#
# Exit code status 
#  1  usaga
#  2  rpmbuild not installed 
#  3  rpmdevtools not installed 
#  4  Java repack jar not disabled
# 
 
# 
# Need params
# 
[[ $# -ne 5 ]] && usage


SPEC="${HOME}/rpmbuild/SPECS"
SOURCES="${HOME}/rpmbuild/SOURCES"
APP_NAME="$1"
TOM_DIR="$2"
DT="`date +"%Y_%m_%d_%H_%M"`"
VERSION="$3" 
RELEASE="$4"
DEST_PATH="$5"

#RPM_BUILD_ROOT="/tmp/rpmbuilder_${DT}"


# Check if rpmbuild is installed 
if [ ! -f "/usr/bin/rpmbuild" ]; then 
	echo "Install RPMBuild" 
	exit 2
fi 

# Check if rpm is installed 
if [ ! -f "/usr/bin/rpmdev-setuptree" ]; then 
	echo "Install rpmdevtools " 
	exit 3
fi 


# Disable /usr/lib/rpm/redhat/brp-java-repack-jars 
REPACK_COUNT=`wc -l /usr/lib/rpm/redhat/brp-java-repack-jars|awk '{print $1}' ` 


if [ ${REPACK_COUNT} -gt 5 ]; then 
	echo "Should disable /usr/lib/rpm/redhat/brp-java-repack-jars" 
	echo " Run \" > /usr/lib/rpm/redhat/brp-java-repack-jars\" " 
	exit 4 

fi 
# This will setup the rpmbuild tree 

/usr/bin/rpmdev-setuptree 

# Copy the war file to rpmbuild/SOURCES
cp -rv ${TOM_DIR} ${SOURCES}

# Touch the spec file 
touch "${SPEC}/${APP_NAME}_${DT}.spec"


# Tom_dir may be a full path 
# Get only the name of dir 
TOM_DIR=`basename ${TOM_DIR}`

echo $TOM_DIR 
# Generate the spec file. 
(
cat <<EOF
Summary: ${APP_NAME} Tomcat ${DEST_PATH}
Name: ${APP_NAME}
Version: ${VERSION}
Release: ${RELEASE}
Group: CLTP
License: GPL 
Packager: infra 
%description 
${APP_NAME} tomcat without app

%install 
mkdir -p \${RPM_BUILD_ROOT}/${DEST_PATH}/${APP_NAME}
cp -r ../SOURCES/${TOM_DIR}/*  \${RPM_BUILD_ROOT}/${DEST_PATH}/${APP_NAME}

%files 
${DEST_PATH}/${APP_NAME} 
# END_OF_SPEC
EOF
 
) > "${SPEC}/${APP_NAME}_${DT}.spec"

echo "----------------------------- "
echo   spec file 
cat "${SPEC}/${APP_NAME}_${DT}.spec"
echo "----------------------------- "

RPM_BUILD_ROOT="/tmp/rpmbuilder_${DT}"

/usr/bin/rpmbuild -vv -ba --buildroot ${RPM_BUILD_ROOT}  "${SPEC}/${APP_NAME}_${DT}.spec"
#/usr/bin/rpmbuild -ba  "${SPEC}/${APP_NAME}_${DT}.spec"

if [ $? -ne 0 ]; 
then 
	rm -rf ${RPM_BUILD_ROOT}
	exit 1 
fi 


# Do the clean up here 
rm -rf ${RPM_BUILD_ROOT}

exit 0 	

