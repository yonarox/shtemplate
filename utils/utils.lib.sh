#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# utils.lib.sh
# -
#
# Andres Aquino <aquino(at)hp.com>
# Hewlett-Packard Company | EBS
# 

# Predefined variables
_ULAND="`uname -s`"
_UHOST=`hostname | sed -e "s/\..*//g"`
_UDATE=`date "+%Y%m%d"`
_UHOUR=`date "+%H%M"`
_UTIME="${_UDATE}${_UHOUR}"
_UUSER=`id -u -n`
_UNAME="Andres Aquino"
_UMAIL="aquino(at)hp.com"
_UWORK="Hewlett-Packard Company"
_UDEBG=true

# set environment
loadenvironment()
{
  logto "Loading environment"

  # Java Environment
  export JAVA_HOME=
  export SHLIB_PATH=

  # get IP Address
  IFACE=
  [ "${_ULAND}" = "HP-UX" ]  && IFACE=lan1
  [ "${_ULAND}" = "Linux" ]  && IFACE=eth0
  [ "${_ULAND}" = "Darwin" ] && IFACE=en0
  _IPADDR=`ifconfig ${IFACE} | awk '/inet [addr:]*/ {print $2}' | sed -e "s/.*://g"`

  # setting locale and editor 
  CLTYPE="\033"
  [ "${_ULAND}" = "Linux" ] && CLTYPE="\e" 
  [ "${_ULAND}" != "HP-UX" ] && LANG="en_US.UTF-8"

  # loading a terminal or only a process
  stty 2> /dev/null > /dev/null 
  if [ "$?" = "0" ]
  then
    stty erase "^?"
    stty intr "^C" 
    stty kill "^U" 
    stty stop "^S"
    stty susp "^Z"
    stty werase "^W"

    # command line _eye candy_
    CRESET="${CLTYPE}[0m"    # Text Reset
    TXTBLK="${CLTYPE}[0;30m" # Black - Regular
    TXTRED="${CLTYPE}[0;31m" # Red
    TXTGRN="${CLTYPE}[0;32m" # Green
    TXTYLW="${CLTYPE}[0;33m" # Yellow
    TXTBLU="${CLTYPE}[0;34m" # Blue
    TXTPUR="${CLTYPE}[0;35m" # Purple
    TXTCYN="${CLTYPE}[0;36m" # Cyan
    TXTWHT="${CLTYPE}[0;37m" # White
    BLDBLK="${CLTYPE}[1;30m" # Black - Bold
    BLDRED="${CLTYPE}[1;31m" # Red
    BLDGRN="${CLTYPE}[1;32m" # Green
    BLDYLW="${CLTYPE}[1;33m" # Yellow
    BLDBLU="${CLTYPE}[1;34m" # Blue
    BLDPUR="${CLTYPE}[1;35m" # Purple
    BLDCYN="${CLTYPE}[1;36m" # Cyan
    BLDWHT="${CLTYPE}[1;37m" # White
    UNKBLK="${CLTYPE}[4;30m" # Black - Underline
    UNDRED="${CLTYPE}[4;31m" # Red
    UNDGRN="${CLTYPE}[4;32m" # Green
    UNDYLW="${CLTYPE}[4;33m" # Yellow
    UNDBLU="${CLTYPE}[4;34m" # Blue
    UNDPUR="${CLTYPE}[4;35m" # Purple
    UNDCYN="${CLTYPE}[4;36m" # Cyan
    UNDWHT="${CLTYPE}[4;37m" # White
    BAKBLK="${CLTYPE}[40m"   # Black - Background
    BAKRED="${CLTYPE}[41m"   # Red
    BAKGRN="${CLTYPE}[42m"   # Green
    BAKYLW="${CLTYPE}[43m"   # Yellow
    BAKBLU="${CLTYPE}[44m"   # Blue
    BAKPUR="${CLTYPE}[45m"   # Purple
    BAKCYN="${CLTYPE}[46m"   # Cyan
    BAKWHT="${CLTYPE}[47m"   # White

  else
    # command line _eye candy_
    CRESET="${CLTYPE}[0m"    # Text Reset
    TXTBLK="${CLTYPE}[0;30m" # Black - Regular
    TXTRED="" # Red
    TXTGRN="" # Green
    TXTYLW="" # Yellow
    TXTBLU="" # Blue
    TXTPUR="" # Purple
    TXTCYN="" # Cyan
    TXTWHT="" # White

  fi

}

# Prints a message 
printto()
{
  local message="${1}"

  _echo=`which echo`
  case "${_ULAND}" in
    "HP-UX")
      ${_echo} "${message}"
    ;;
      
    "Linux")
      echo -e -n "${message} \n"
    ;;
    
    "Darwin")
      echo -e -n "${message} \n"
    ;;
      
    *)
      ${_echo} "${message} "
    ;;
  esac

}

loadprofile()
{
  local uprofile=${1}
  if [ -s ${uprofile} ]
  then
    . ${uprofile} > /dev/null 2>&1
    logto "Load profile ${uprofile}"
  fi

}

# Set a java environment
javaenvironment()
{
  local JAVA_ENV="${1}"

  # if not exist or is empty, exit 
  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

  # rebuild path and validate
  local JAVA_PROF="${HOME}/paths.d/${JAVA_ENV}"
  
  # java path file? 
  grep -q java "${JAVA_PROF}" || return 0

  # reload paths to eliminate some java previous settings
  localpaths

  # rebuild path with java home
  for eachpath in $(cat ${JAVA_PROF})
  do
    # expand vars
    eachpath="$(eval echo ${eachpath})"
    if [ -d ${eachpath}/bin ] 
    then
      PATH=${eachpath}/bin:${PATH}
      logto "Adding new path: ${eachpath}/bin"

      JAVA_HOME=${eachpath}
      JAVA_VERSION=`java -version 2>&1 | grep "version" | sed -e "s/\"//g;s/.*ion //g"`
      logto "Setting JAVA_HOME to ${eachpath}, Ver. ${JAVA_VERSION}"
      
      # workaround hp-ux & java16
      [ ${_ULAND} = "HP-UX" ] && [ ${JAVA_ENV} = "java16" ] && SHLIB_PATH=${JAVA_HOME}/jre/lib/PA_RISC2.0/jli
      return 0
    fi
  done

}

# Define a execution unix path reading each file in Paths.d
localpaths () 
{
  LPATH=

  # if not exist or is empty, exit 
  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

  for pathfile in ${HOME}/paths.d/*
  do
    # empty file
    [ ! -s ${pathfile} ] && continue
    
    # include java path
    grep -q java ${pathfile} && continue 

    # for each file, get paths and add to execution path
    for eachpath in $(cat ${pathfile})
    do
      # get one line (path) and verify: is this a directory? 
      eachpath="$(eval echo ${eachpath} | sed -e 's/ *//g')"
      [ ! -d ${eachpath} ] && break 

      LPATH=${eachpath}:${LPATH}
      logto "Adding new path: ${eachpath}"
    done
  done

  # User binaries  
  [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

  LPATH=.:${LPATH}
  PATH=${LPATH}:${_PATH}

}

# logger
logto ()
{
  local message=${1}
  ${_UDEBG} && printto "> ${message}"
}

# Shows MD5 of this profile
version () 
{
  alias defn="declare"
  [ "${_ULAND}" = "HP-UX" ] && alias defn="typeset"
  _URELS=`defn -f version | openssl dgst -md5 | rev | cut -c-4 | rev`
  printto "Profile ver. (${_URELS}) | ${_ULAND} \n${_UWORK} \n\nDeveloped by \nAndres Aquino <aquino(at)hp.com>"
}

