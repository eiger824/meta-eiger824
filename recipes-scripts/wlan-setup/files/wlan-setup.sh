#!/bin/bash
#
#
# (For security reasons, both the $SSID and $PASS variables must be given
# to this script externally, first to make it general for every network
# and to avoid hardcoding passwords)
#
# So first we check if the variables have been provided

if [[ ! -z $SSID ]] && [[ ! -z $PASS ]]
then
	echo -e "Input SSID: $SSID \nInput pass: [hidden]"
else
	echo "Please run this script as SSID=<some-ssid> PASS=<password> $(basename $0)"
	exit 1
fi

# Name of the interface
IFACE="wlan0"
# WiFi supplicant file
WFILE="/etc/wpa_supplicant.conf"

if [[ -z $(ip link show | grep $IFACE) ]]
then 
	echo "Checking that $IFACE is visible ... [fail]"
	exit 1
fi
echo "Checking that $IFACE is visible ... [ok]"

if [[ -z $(ifconfig | grep $IFACE) ]]
then
	echo "Checking that $IFACE is up ... [fail]"
	ifup wlan0 &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "Interface is up!!"
	else
		echo "Error setting $IFACE up, aborting..."
		exit 1
	fi
fi
echo "Checking that $IFACE is up ... [ok]"

if [[ -z $(iwlist $IFACE scan | grep $SSID | sed -e 's/^\s\+//g') ]]
then
	echo "Checking that out network exists ... [fail]"
	exit 1
fi
echo "Checking that ourD SSID exists ... [ok]"

if [[ ! -z $(grep $SSID $WFILE) ]]
then
	echo "[$SSID] already registered, overwriting ..."
	#cat $WFILE | sed -e 's/ssid='$SSID'/#ssid='$SSID''
else
	echo -e "\n#======\n#Our WiFi" >> $WFILE
	wpa_passphrase "$SSID" "$PASS" | grep -v "^\s\+#" >> $WFILE
fi

echo "Forcing connection ..."
wpa_cli reconfigure

# Sleep animation while waiting for IP
for i in `seq 1 20`
do
	echo -ne "\rAdding route "
	for j in `seq 1 $i`
	do
		echo -n "* "
	done
	sleep 1
done
echo
# Add route to routing table!
route add default gw 192.168.0.1 wlan0
echo "Adding route ... [ok]"
