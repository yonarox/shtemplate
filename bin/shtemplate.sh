#!/bin/sh 
# vim: set ts=2 sw=2 sts=2 et si ai: 

# shtemplate.sh
# =
# 
# Andres Aquino <aquino(at)hp.com>
# Hewlett Packard Company | EBS
# 

# default enviroment
_ANAME=`basename ${0%.*}`
_ADEBG=

# application's enviroment
. ${HOME}/.shtemplaterc

# load user functions
. ${_APATH}/utils/commons-sh.lib
. ${_APATH}/utils/commons-java.lib



set_environment

# soya's environment
VERSION="`cat ${APPATH}/VERSION | sed -e 's/-rev/ Rev./g'`"
RELEASE=`openssl dgst -md5 ${APPATH}/${APNAME}.sh | rev | cut -c-4 | rev`
SCRPRCS=`echo ${APLINK} | sed -e "s/[a-zA-Z\.-]/0/g;s/.*\([0-9][0-9]\)$/\1/g"`
APTYPE="AP"
[ ${APLINK} != ${APNAME} ] && APTYPE=`grep -i aptype ${APLINK}.conf | sed -e "s/.*=//g" 2> /dev/null`

# send version
log_action "DEBUG" "You're using ${APNAME} ${VERSION} release ${RELEASE}"


#
