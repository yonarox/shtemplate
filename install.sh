#!/bin/sh 
# vim: set ts=2 sw=2 sts=2 si ai et: 

# install.sh 
# =
#
# Andres Aquino <aquino(at)hp.com>
# Hewlett-Packard Company
# 

echo "[1] - Creating structure..."
mkdir -p ~/bin
mkdir -p ~/manuals/man1

echo "[2] - Migrating all config files to new version..."
cd ~/shtemplate.git/conf/
[ -d ~/shtemplate ] && cp -rp ~/shtemplate/conf/*.conf .
for ap in *.conf
do
  ln -sf ../shtemplate.sh ${ap%.conf}.start
done

echo "[3] - Switching to new version..."
cd ~
[ -d ~/shtemplate.old ] && rm -fr ~/shtemplate.old
[ -d ~/shtemplate ] && mv ~/shtemplate ~/shtemplate.old
[ -d ~/shtemplate.git ] && mv ~/shtemplate.git ~/shtemplate

echo "[4] - Installing unix documentation..."
cp ~/shtemplate/man1/shtemplate.1 ~/manuals/man1/
ln -sf ~/shtemplate/shtemplate.sh ~/shtemplate/shtemplate.version
ln -sf ~/shtemplate/shtemplaterc ~/.shtemplaterc
ln -sf ~/shtemplate/screenrc ~/.screenrc

echo "[5] - Fixing permissiont..."
chmod 0640 ~/shtemplate/install.sh 
chmod 0550 ~/shtemplate/shtemplate.sh

echo "[*] - That's all..."
#
# get current directory
CURRENT=`dirname ${0}`
if [ ${CURRENT} == "." ]
then
  echo "please, move to application's directory"
  exit 1
fi

# create RC file
[ -h ${HOME}/.shtemplaterc ] && rm -f ${HOME}/.shtemplaterc
ln -sf ${CURRENT}/setEnvironment.rc ${HOME}/.shtemplaterc 

#
