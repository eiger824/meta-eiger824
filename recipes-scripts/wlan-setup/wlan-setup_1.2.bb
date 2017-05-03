DESCRIPTION = "A script that sets up WiFi on the raspberry pi"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r3"

SRC_URI = "file://wlan-setup.sh"

RDEPENDS_${PN} += "bash"

do_install() {
	install -d -m 0755 ${D}/${sysconfdir}/scripts
	install -m 0755 wlan-setup.sh ${D}/${sysconfdir}/scripts/wlan-setup.sh
}

FILES_${PN} += " \
	${sysconfdir}/scripts/wlan-setup.sh \
	"

