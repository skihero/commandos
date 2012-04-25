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
	echo "Usage: $0 appname war_file "
	exit 1
}
 
# 
# Need params
# 
[[ $# -eq 0 ]] && usage


SPEC="${HOME}/rpmbuild/SPECS"
APP_NAME="$1"
WAR_FILE="$2"
DT="`date +"%Y_%m_%d_%H_%M"`"

# This will be populated in the 
# spec file 
RPM_BUILD_ROOT="/tmp/rpmbuilder_${DT}"



# Check if rpmbuild is installed 
if [ ! -f "/usr/bin/rpmbuild" ]; then 
	echo "Install RPMBuild" 
	exit 2
fi 

# Check if rpm is installed 
if [ ! -f "/usr/bin/rpmbuild" ]; then 
	echo "Install rpmdevtools " 
	exit 3
fi 

# Touch the spec file 
touch "${SPEC}/${APP_NAME}_${DT}.spec"

# Generate the spec file. 
cat << EOF >> "${SPEC}/${APP_NAME}_${DT}.spec"
Summary: ${APP_NAME} Tomcat application
Name: ${APP_NAME}
Version: 1
Release: 0
Group: CLTP
License: GPL 
Packager: CI_Chain
%description 
${APP_NAME} war file rpm

%install 
mkdir -p ${RPM_BUILD_ROOT}/usr/local/release3/tomcat/webapps/wouldbe
cp -r ../SOURCES/${WAR_FILE}  ${RPM_BUILD_ROOT}/usr/local/release3/tomcat/webapps/wouldbe

%files 
%attr(745, root, -) /usr/local/release3/tomcat/webapps/wouldbe/${WAR_FILE}

%post 
mv /usr/local/release3/tomcat/webapps/wouldbe/${WAR_FILE} /usr/local/release3/tomcat/webapps/

EOF 


# This will build the build tree 

/usr/bin/rpmdev-setuptree 
#/usr/bin/rpmbuild -ba --buildroot /tmp/rpmbuilder  "${SPEC}/${APP_NAME}_${DT}.spec"
/usr/bin/rpmbuild -ba  "${SPEC}/${APP_NAME}_${DT}.spec"

if [ $? -ne 0 ]; 
then 
	rm -rf ${RPM_BUILD_ROOT}
	exit 1 
fi 


# Do the clean up here 
rm -rf ${RPM_BUILD_ROOT}

exit 0 	

