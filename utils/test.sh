#!/bin/sh 
# vim: set ts=2 sw=2 sts=2 et si ai: 

# test.sh 
# =
# 
# Andres Aquino <aquino(at)hp.com>
# Hewlett Packard Company | EBS
# 

. ~/Dropbox/hp.com/shtemplate.git/utils/commons-sh.lib

_UDEBG=true
_UCOLR=true

echo $-
init_environment
set_profile ~/host.info
set_paths
status "Loading new profiles "
status 0 "Loading new profiles "
status -1 "Loading new profiles "


# 
