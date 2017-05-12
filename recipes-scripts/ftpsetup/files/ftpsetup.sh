#!/bin/bash

#set -e

MOUNTPOINT="/media/ftpserver"
SERVERDEVADDR="/dev/sda"
SERVERPARTADDR="/dev/sda2"

FTPCONFFILE="/etc/vsftpd.conf"
FTPUSERLIST="/etc/vsftpd.user_list"
FTPGROUP="warriors"

VERSION=1.3

help() {
	echo "USAGE: $0 [ARGS]"
	echo "ARGS:"
	echo -e "-d\t--delete USER\t\tDeletes USER"
	echo -e "-n\t--new-user USER\t\tAdds USER with permissions to user ftp server"
	echo -e "-m\t--mount-point DIR\tSets mount point for FTP server (defaults to $MOUNTPOINT)"
	echo -e "-h\t--help\t\t\tShows this help and exits"
	echo -e "-v\t--version\t\tShows version and exits"
}

# Initial arg check
if [ $# -eq 0 ]
then
	echo "No input args."
	help
	exit 1
fi

# Parse args
#for i in $@
while [[ $# -gt 0 ]]
do
	case $1 in
	-h|--help)
		help
		exit
	;;
	-d|--delete)
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
				echo -n "Found '$FTPUSER, removing ...'"
				userdel -r $FTPUSER &> /dev/null
				echo -e "\rFound '$FTPUSER', removing ...[OK]"
				echo "Removing $FTPUSER's dir in FTP server ..."
				rm -rf $MOUNTPOINT/FTPServer/$FTPUSER
				echo "Removing '$FTPUSER' from $FTPUSERLIST"
				sed -i -e 's/'$FTPUSER'//' -e '/^\s*$/d' $FTPUSERLIST
				echo "Done!"
				exit 0
			else
				echo "Error, user '$FTPUSER' does not exist"
				help
				exit 1
			fi
		fi
	# And shift
	shift
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
						while(true)
						do
							passwd $FTPUSER
							if [ "$?" == "0" ]
							then
								break
							fi
						done
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

# Create warriors group if non-existent
groupadd $FTPGROUP &> /dev/null
if [ "$?" == "0" ]
then
	echo "Added '$FTPGROUP'"
else
	echo "'$FTPGROUP' already exists, skipping"
fi

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


#######################################################################
# Apply the changes to the vsftpd conf file
if [[ ! -z $(grep "^userlist_deny" $FTPCONFFILE) ]]
then
        # Now we want to check if it is correct or not (we want NO)
        ENABLED=`grep "^userlist_deny" $FTPCONFFILE | cut -d"=" -f2`
        if [ "$ENABLED" == "YES" ]
        then
		sed -i -e 's/userlist_deny='$ENABLED'/userlist_deny=NO/g' $FTPCONFFILE
        fi
else
        # Then simply append it at the end
        echo 'userlist_deny=NO' >> $FTPCONFFILE
fi

if [[ ! -z $(grep "^chroot_local_user" $FTPCONFFILE) ]]
then
        # Now we want to check if it is correct or not (we want YES)
        ENABLED=`grep "^chroot_local_user" $FTPCONFFILE | cut -d"=" -f2`
        if [ "$ENABLED" == "NO" ]
        then
		sed -i -e 's/chroot_local_user='$ENABLED'/chroot_local_user=YES/g' $FTPCONFFILE
        fi
else
        # Then simply append it at the end
        echo 'chroot_local_user=YES' >> $FTPCONFFILE
fi

if [[ ! -z $(grep "^local_root" $FTPCONFFILE) ]]
then
        # Now we want to check if it is correct or not (we want YES)
        DIR=`grep "^local_root" $FTPCONFFILE | cut -d"=" -f2`
        if [ "$DIR" != "$MOUNTPOINT/FTPServer/\$USER" ]
        then
		sed -i -e '/^local_root/d' $FTPCONFFILE
                echo 'local_root='$MOUNTPOINT'/FTPServer/$USER' >> $FTPCONFFILE
        fi
else
        # Then simply append it at the end
        echo 'local_root='$MOUNTPOINT'/FTPServer/$USER' >> $FTPCONFFILE
fi

if [[ ! -z $(grep "^user_sub_token" $FTPCONFFILE) ]]
then
        # Now we want to check if it is correct or not (we want YES)
        TOKEN=`grep "^user_sub_token" $FTPCONFFILE | cut -d"=" -f2`
        if [ "$TOKEN" != "\$USER" ]
        then
		sed -i -e '/^user_sub_token/d' $FTPCONFFILE
                echo 'user_sub_token=$USER' >> $FTPCONFFILE
        fi
else
        # Then simply append it at the end
        echo 'user_sub_token=$USER' >> $FTPCONFFILE
fi
#######################################################################

echo "Configuring..."
echo -e "\tChanging mode to parent dir ..."
chmod 770 $MOUNTPOINT/FTPServer
echo -e "\tChanging mode to chroot dir ..."
chmod 740 $MOUNTPOINT/FTPServer/$FTPUSER
echo -e "\tChanging ownership for user '$FTPUSER'"
chown -R $FTPUSER:$FTPGROUP $MOUNTPOINT/FTPServer
chown -R $FTPUSER:$FTPGROUP $MOUNTPOINT/FTPServer/$FTPUSER
echo -e "\tAdding '$FTPUSER' to group '$FTPGROUP'"
usermod -G $FTPGROUP $FTPUSER
echo -e "\tRestarting vsftpd service ..."
systemctl restart vsftpd
echo "Done!"
