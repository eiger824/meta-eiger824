#!/bin/bash

set -e

MOUNTPOINT="/media/ftpserver"
SERVERDEVADDR="/dev/sda"
SERVERPARTADDR="/dev/sda2"

FTPUSERLIST="/etc/vsftpd.user_list"

VERSION=1.0

help() {
	echo "USAGE: $0 [ARGS]"
	echo "ARGS:"
	echo -e "-n\t--new-user USER\t\tAdds USER with permissions to user ftp server"
	echo -e "-m\t--mount-point DIR\tSets mount point for FTP server (defaults to $MOUNTPOINT)"
	echo -e "-h\t--help\t\t\tShows this help and exits"
	echo -e "-v\t--version\t\tShows version and exits"
}

# Parse args
#for i in $@
while [[ $# -gt 1 ]]
do
	case $1 in
	-h|--help)
		help
		exit
	;;
	-n|--new-user)
		if [[ -z "$2" ]]
		then
			echo "Error, missing user name"
			help
			exit 1
		else
			FTPUSER=$2
			# Check if exists
			id -u $FTPUSER &> /dev/null
			if [ "$?" == "0" ]
			then
				echo "User $FTPUSER already exists, skipping creation"
			else
				echo "Will add user: " $FTPUSER
				useradd -m --home-dir /home/$FTPUSER $FTPUSER
				while(true)
				do
					echo -n "Set new password? [y/n]: "
					read pass
					case $pass in
					y|Y)
						passwd $FTPUSER
						break
					;;
					n|N)
						echo "Skipping password"
						break
					;;
					*)
						echo "Wrong option"
					;;
					esac
				done
			fi
		fi
	# And shift for next one
	shift
	;;
	-m|--mount-point)
		if [[ -z "$2" ]]
		then
			echo "Error, missing mount point"
			help
			exit 1
		else
			MOUNTPOINT=$2
			echo "Will mount FTP server on $MOUNTPOINT"
		fi
	# And shift for next arg
	shift
	;;
	-v|--version)
		echo "Version: $VERSION"
		exit
	;;
	*)
		echo "Error: unknown argument \"$1\""
		help
		exit 1
	;;
	esac
	# Shift operator to get next one
	shift
done

if [[ -z "$FTPUSER" ]]
then
	echo "Error: ftp username cannot be left blank"
	help
	exit 1
fi

if [ ! -d $MOUNTPOINT ]
then
	echo "Creating mount point"
	mkdir $MOUNTPOINT
fi

echo -n "Checking if FTP is plugged ..."
if [ ! -b $SERVERDEVADDR ]
then
	echo -e "\nConnect external HD to rpi and run this script"
	exit 1
fi
echo -e "\rChecking if FTP is plugged ... [OK]"

echo -n "Checking if FTP is mounted ..."
if [[ -z $(df | grep $SERVERPARTADDR) ]]
then
	echo -ne "\nNot mounted, mounting under /media/ftpserver ..."
	mount $SERVERPARTADDR $MOUNTPOINT
	echo -e "\rNot mounted, mounting under /media/ftpserver ... [OK]"
else
	# In case of mounted anywhere else
	echo -ne "\nMounted, unmounting first ..."
	umount $SERVERPARTADDR && sync
	echo -e "\rMounted, unmounting first ... [OK] "
	echo -n "Re-mounting ..."
	mount $SERVERPARTADDR $MOUNTPOINT
	echo -e "\rRe-mounting ... [OK]"
fi
echo -e "\rChecking if FTP is mounted ... [OK]"

if [ ! -d $MOUNTPOINT/FTPServer/$FTPUSER ]
then
	echo -n "Creating dir for user '$FTPUSER' in /media/ftpserver/FTPServer ..."
	mkdir $MOUNTPOINT/FTPServer/$FTPUSER
	echo -e "\rCreating dir for user '$FTPUSER' in /media/ftpserver/FTPServer ... [OK]"
fi

if [[ -z $(grep $FTPUSER $FTPUSERLIST) ]]
then
	echo -n "Adding $FTPUSER to $FTPUSERLIST list ..."
	echo $FTPUSER >> $FTPUSERLIST
	echo -e "\rAdding $FTPUSER to $FTPUSERLIST list ... [OK]"
else
	echo "User $FTPUSER is already a member of this list, skipping ..."
fi

while(true)
do
	echo -e "----------------------\nAdd following lines to /etc/vsftpd.conf:"
	echo -e "\tchroot_local_user=YES"
	echo -e "\tlocal_root=/media/ftpserver/FTPServer/\$USER"
	echo -e "\tuser_sub_token=\$USER"
	echo -e "\tuserlist_deny=NO"
	echo -e "----------------------"

	echo -n "Done? [y/n]: "
	read ans
	case $ans in
		y)
			echo "Configuring..."
			echo -e "\tChanging mode ..."
			chmod 760 -R $MOUNTPOINT/FTPServer
			echo -e "\tChanging ownership for user '$FTPUSER'"
			chown -R $FTPUSER. $MOUNTPOINT/FTPServer
			echo -e "\tAdding group '$FTPUSER'"
			usermod -G $FTPUSER $FTPUSER
			echo -e "\tRestarting vsftpd service ..."
			systemctl restart vsftpd
			echo "Done!"
			break
			;;
		n)
			echo "Edit /etc/vsftpd.conf file with the proposed lines ..."
			;;
		*)
			echo "Wrong option"
			;;
			
	esac
done
