#!/bin/sh 
# vim: set ts=2 et sw=2 sts=2 si ai:

# unix.profile
# -
#
# Andres Aquino <aquino(at)hp.com>
# Hewlett-Packard Company | EBS
# 

# This is the user profile enviroment file
# See bash_rc or bash_profile for more information.

# Behavior
# input mode
set -o vi

# permissions by default over new files/directories
umask 0007

# Predefined variables
U_LAND="`uname -s`"
U_HOST=`hostname | sed -e "s/\..*//g"`
U_DATE=`date "+%Y%m%d"`
U_HOUR=`date "+%H%M"`
U_TIME="${U_DATE}${U_HOUR}"
U_NAME="Andres Aquino"
U_MAIL="aquino(at)hp.com"
U_WORK="Hewlett-Packard Company | EBS"

# set environment
LoadEnvironment ()
{
  # debug
  ${U_DEBG} || export U_DEBG=true

  # Terminal 
  export U_TERM="TERM"
  export EDITOR=vi
  export LANG="C"

  # Java Environment
  export JAVA_HOME=
  export JRE_HOME=
  export SHLIB_PATH=

  # System binaries
  [ -d /usr/sbin ] && PATH=/usr/sbin:${PATH}
  [ -d /usr/bin ] && PATH=/usr/bin:${PATH}
  [ -d /sbin ] && PATH=/sbin:${PATH}
  [ -d /bin ] && PATH=/bin:${PATH}
 
  # history file and manuals
  export HISTSIZE=1500
  export HISTCONTROL=ignoredups
  export MANPATH=${HOME}/manuals:${MANPATH}

  # Terminal settings by SO
  export HOSTNAME=`hostname`
  export TERM="xterm"
  export CLICOLOR="hxfxcxdxbxegedabagacad"
  export LSCOLORS="hxfxcxdxbxegedabagacad"

  # get IP Address 
  IFACE=
  [ "${U_LAND}" = "HP-UX" ]  && IFACE=lan
  [ "${U_LAND}" = "Linux" ]  && IFACE=eth
  [ "${U_LAND}" = "Darwin" ] && IFACE=en

  # .. from two network interfaces
  for NDEV in 0 1 2 3 4
  do
    _IFACE="${IFACE}${NDEV}"
    _IPADDR=`ifconfig ${_IFACE} 2> /dev/null| awk '/inet [addr:]*/ {print $2}' | sed -e "s/.*://g"`
    [ -n "${_IPADDR}" ] && break
  done
  
  # sweet lo0, sweet localhost 
  [ ! -n "${_IPADDR}" ] && _IPADDR="127.0.0.1"

  # setting locale  
  CLTYPE="\033"
  [ "${U_LAND}" = "Linux" ] && CLTYPE="\e" 
  [ "${U_LAND}" != "HP-UX" ] && EDITOR=vim && LANG="en_US.UTF-8"

  # loading a terminal or only a process
  stty 2> /dev/null | grep -q 'baud' 
  if [ $? -eq 0 ]
  then
    stty erase "^?"
    stty intr "^C" 
    stty kill "^U" 
    stty stop "^S"
    stty susp "^Z"
    stty werase "^W"

    # command line _eye candy_
    U_TERM="CONSOLE"

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
    U_TERM="TERM"
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

  # Common alias
  alias ls="ls -F"
  alias ll="ls -l"
  alias la="ll -a"
  alias lt="la -t"
  alias lr="lt -r"
  alias pw="pwd"
  alias java16="JavaEnvironment java16"
  alias java15="JavaEnvironment java15"
  alias java14="JavaEnvironment java14"
  alias java13="JavaEnvironment java13"
  alias version="ShowVersion"
  _echo=`which echo`
 
}

# Prints a message 
PrintOut ()
{
  message="${1}"

  case "${U_LAND}" in
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

LoadProfile ()
{
  uprofile=${1}
  if [ -s ${uprofile} ]
  then
    . ${uprofile} > /dev/null 2>&1
    bname=`basename ${uprofile}`
    LogInfo "Loading profile ${bname}"
  fi

}

# Set a java environment

JavaEnvironment ()
{
  JAVA_ENV="${1}"

  # if not exist or is empty, exit 
  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

  # rebuild path and validate
  JAVA_PROF="${HOME}/paths.d/${JAVA_ENV}"
  
  # java path file? 
  grep -q java "${JAVA_PROF}" || return 0

  # reload paths to eliminate some java previous settings
  SetLocalPaths

  # Workaround
  # for OS-X systems, java commands are in Commands/ 
  _binpath="bin"
  [ ${U_LAND} = "Darwin" ] && _binpath="Commands"

  # rebuild path with java home
  for eachpath in $(cat ${JAVA_PROF})
  do
    # expand vars
    eachpath="$(eval echo ${eachpath})"
    if [ -d ${eachpath}/${_binpath} ] 
    then
      # FIX:
      # must to use java bin of JRE_HOME firts 
      JAVA_HOME=${eachpath}
      JRE_HOME=${JAVA_HOME}/jre
      [ -d ${JAVA_HOME} ] && PATH=${JAVA_HOME}/${_binpath}:${PATH}
      [ -d ${JRE_HOME}  ] && PATH=${JRE_HOME}/${_binpath}:${PATH}
      LogInfo "Adding new path: ${eachpath}/${_binpath}"

      JAVA_VERSION=`java -version 2>&1 | grep "version" | sed -e "s/\"//g;s/.*ion //g"`
      LogInfo "Setting JAVA_HOME to ${eachpath}, Ver. ${JAVA_VERSION}"
      
      # workaround hp-ux & java16
      [ ${U_LAND} = "HP-UX" ] && [ ${JAVA_ENV} = "java16" ] && SHLIB_PATH=${JAVA_HOME}/jre/lib/PA_RISC2.0/jli
      return 0
    fi
  done

}

# Define a execution unix path reading each file in Paths.d
SetLocalPaths ()
{
  LPATH=

  # if not exist or is empty, exit 
  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

  for pathfile in ${HOME}/paths.d/[0-9][0-9]*
  do
    # empty file
    [ ! -s ${pathfile} ] && continue
    
    # include java path
    grep -q java ${pathfile} && continue 

    # for each file, get paths and add to execution path
    bname=`basename ${pathfile}`
    isValid=false
    for eachpath in $(cat ${pathfile})
    do
      # get one line (path) and verify: is this a directory? 
      eachpath="$(eval echo ${eachpath} | sed -e 's/ *//g')"
      [ ! -d ${eachpath} ] && break 
      
      isValid=true
      #LPATH=${eachpath}:${LPATH}
      LPATH=${LPATH}:${eachpath}
    done
    ${isValid} && LogInfo "Loading paths ${bname}"
  done

  # User binaries  
  [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

  LPATH=.:${LPATH}
  PATH=${LPATH}:${U_PATH}

}

# Sets PS1 and PS2 using an _eye candy_ cmd line, if you're using Git it shows branch name
SetCommandStyle ()
{
  export _USERNAME=${U_NAME}
  export _USERMAIL=${U_MAIL}
  export _USERWORK=${U_WORK}

  [ "${U_TERM}" = "TERM" ] && return 0
  if [ "${U_LAND}" = "HP-UX" ]
  then
    export PS1="$(echo "\n${CRESET}[ ${TXTYLW}${_IPADDR}${CRESET} | ${U_HOST} ] \${PWD} \n${TXTWHT}${USER} ${CRESET}\$ ")"
  else
    if [ -s ~/git.profile ]
    then
      export PS1="\e]1;${_IPADDR}\a\e]2;${_IPADDR}:${U_HOST}\a\
                  \n\[${CRESET}\][ \[${TXTYLW}\]${_IPADDR}\[${CRESET}\] | ${U_HOST} ]\[${BLDGRN}\]\$(__git_ps1 '(%s)')\[${CRESET}\] \w \
                  \n\[${TXTWHT}\]${USER}\[${CRESET}\] \$ "
    else
      export PS1="\e]1;${_IPADDR}\a\e]2;${_IPADDR}:${U_HOST}\a\
                  \n\[${CRESET}\][ \[${TXTYLW}\]${_IPADDR}\[${CRESET}\] | ${U_HOST} ] \w \
                  \n\[${TXTWHT}\]${USER}\[${CRESET}\] \$ "
    fi
  fi
  export PS2=" ..> "
  unset USERNAME
}

# logger
#LogInfo ()
#LogError ()
#LogAction ()
LogInfo ()
{
  message=${1}
  [ "${U_TERM}" = "TERM" ] && return 0
  ${U_DEBG} && PrintOut "${TXTBLU} >>  ${TXTWHT}${message}${CRESET}"

}

LogError ()
{
  message=${1}
  [ "${U_TERM}" = "TERM" ] && return 0
  ${U_DEBG} && PrintOut "${TXTRED} *  ${TXTWHT}${message}${CRESET}"
}

LogMessage ()
{
  message=${1}
  [ "${U_TERM}" = "TERM" ] && return 0
  PrintOut "${CRESET}${message}"

}

# Shows MD5 of this profile
ShowVersion ()
{
  alias defn="declare"
  [ "${U_LAND}" = "HP-UX" ] && alias defn="typeset"
  _URELS=`openssl dgst -md5 ~/unix.profile | rev | cut -c-4 | rev`
  PrintOut "Profile ver.${_URELS} (${U_LAND}) \n${U_WORK} \n\nDeveloped by \nAndres Aquino <aquino(at)hp.com>"
}

SetWorkProfile () {
  LoadProfile ~/host-office.info

}

SetHomeProfile () {
  LoadProfile ~/host-home.info

}

