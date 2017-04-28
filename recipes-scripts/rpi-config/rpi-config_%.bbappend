do_deploy_append() {
	if [ -f ${DEPLOYDIR}/bcm2835-bootfiles/config.txt ]; then
		echo "" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "# Disable rainbow colored square " >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "avoid_warnings=1" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "# Disable initial firmware color test" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "disable_splash=1" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "# Rotate lcd 180 degrees" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "lcd_rotate=2" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "# Overlay for touchscreen driver" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
		echo "dtoverlay=rpi-ft5406" >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
	fi
}
