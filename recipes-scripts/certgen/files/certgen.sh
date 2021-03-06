#!/bin/bash

DIR="/etc/nginx"
CERT="$DIR/mysland.pem"
KEY="$DIR/mysland.key"
CONFFILE="$DIR/nginx.conf"
# Generate CSR & private key

if [ ! -f $KEY ] || [ ! -f $CERT ]
then
	openssl req -newkey rsa:2048 -nodes -keyout $KEY \
		-x509 -days 365 -out $CERT
else
	while(true)
	do
		echo -n "key and/or domain files exist. replace? [y/n]:"
		read ans
		case $ans in
		y|Y)
			openssl req -newkey rsa:2048 -nodes -keyout $KEY \
                -x509 -days 365 -out $CERT
		break
		;;
		n|N)
			echo "Aborting ..." &> /dev/null
			break;
		;;
		*)
			echo "Wrong option"
		;;
		esac
	done
fi

# Last check, to see if generated names match https server
if [[ -z $(grep `basename $KEY` $CONFFILE) ]] || [[ -z $(grep `basename $CERT` $CONFFILE) ]]
then
	echo "Check that the generated key/cert matches the name in nginx.conf file"
	exit 1
fi
