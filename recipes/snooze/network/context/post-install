#!/bin/bash

cd /mnt
LOGFILE=$(mktemp)
echo "#START OF POST-INSTALL" > /dev/ttyS0


# source functions lib
. lib/functions >> $LOGFILE 2>&1

# setup some vars
set_distribution >> $LOGFILE 2>&1

# add ssh key
add_ssh_key >> $LOGFILE 2>&1

# run scripts
[ -d "distributions/$DISTRIBUTION" ] && run-parts distributions/$DISTRIBUTION >> $LOGFILE 2>&1

sleep 2 #to be sure network is up

###
# Customization :
# - Add all customizations that you want here.
###
