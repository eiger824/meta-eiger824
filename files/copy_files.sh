#!/bin/bash

set -e

LOCAL_CONF=/home/$USER/poky-morty/build/conf/local.conf
BBLAYERS_CONF=/home/$USER/poky-morty/build/conf/bblayers.conf

if [ -f $LOCAL_CONF ]
then
	echo File found, creating backup
	mv $LOCAL_CONF "$LOCAL_CONF".bkup
fi

# and copy it
cp ./local.conf $(dirname $LOCAL_CONF)

if [ -f $BBLAYERS_CONF ]
then
	echo File found, creating backup
	mv $BBLAYERS_CONF "$BBLAYERS_CONF".bkup
fi

# and copy it
cp ./bblayers.conf $(dirname $BBLAYERS_CONF)

echo Done
