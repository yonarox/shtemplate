#!/bin/sh 
# vim: set filetype=sh ts=2 sw=2 sts=2 et si ai: 

# decryptMe.sh
# =
#
# Andres Aquino <aquino(at)hp.com>
# Hewlett-Packard Company | EBS
# 

. ${HOME}/.shelltemplaterc

# encrypted file
encryptedFile="${1}"

echo "Decrypting file..."
info=`openssl enc -d -aes256 -salt -pass file:${AP_KEYF} -in ${encryptedFile}`

# show information
echo " param[user]: ${info%@*}"
echo " param[pswd]: ${info#*@}"


# 
