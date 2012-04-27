#!/bin/bash 
#
# Read the war and produce rpm
#
#

set -x 

#
# Usage 
#  
usage(){
	echo "Usage: $0 appname war_file version release"
	exit 1
}

# Exit code status 
#  1  usaga
#  2  rpmbuild not installed 
#  3  rpmdevtools not installed 
#  4  Java repack jar not disabled
# 
 
# 
# Need params
# 
[[ $# -ne 4 ]] && usage


SPEC="${HOME}/rpmbuild/SPECS"
SOURCES="${HOME}/rpmbuild/SOURCES"
APP_NAME="$1"
WAR_FILE="$2"
DT="`date +"%Y_%m_%d_%H_%M"`"
VERSION="$3" 
RELEASE="$4"

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
cp -v ${WAR_FILE} ${SOURCES}

# Touch the spec file 
touch "${SPEC}/${APP_NAME}_${DT}.spec"


# Generate the spec file. 
(
cat <<EOF
Summary: ${APP_NAME} Tomcat application
Name: ${APP_NAME}
Version: ${VERSION}
Release: ${RELEASE}
Group: CLTP
License: GPL 
Packager: CI_Chain
%description 
${APP_NAME} war file rpm

%install 
mkdir -p \${RPM_BUILD_ROOT}/usr/local/release3/tomcat/webapps/wouldbe
cp -r ../SOURCES/${WAR_FILE}  \${RPM_BUILD_ROOT}/usr/local/release3/tomcat/webapps/wouldbe

%files 
%attr(745, root, -) /usr/local/release3/tomcat/webapps/wouldbe/${WAR_FILE}

%post 
mv /usr/local/release3/tomcat/webapps/wouldbe/${WAR_FILE} /usr/local/release3/tomcat/webapps/
# END_OF_SPEC
EOF
 
) > "${SPEC}/${APP_NAME}_${DT}.spec"

RPM_BUILD_ROOT="/tmp/rpmbuilder_${DT}"

/usr/bin/rpmbuild -ba --buildroot ${RPM_BUILD_ROOT}  "${SPEC}/${APP_NAME}_${DT}.spec"
#/usr/bin/rpmbuild -ba  "${SPEC}/${APP_NAME}_${DT}.spec"

if [ $? -ne 0 ]; 
then 
	rm -rf ${RPM_BUILD_ROOT}
	exit 1 
fi 


# Do the clean up here 
rm -rf ${SOURCES}/${WAR_FILE}
rm -rf ${RPM_BUILD_ROOT}

exit 0 	

