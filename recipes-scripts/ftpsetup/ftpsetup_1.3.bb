DESCRIPTION = "A simple script that sets up an external USB disk as a FTP server and adds a user"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r3"

SRC_URI = "file://ftpsetup.sh"

RDEPENDS_${PN} += "bash"

do_install() {
	install -d -m 0755 ${D}/${sysconfdir}/scripts
	install -m 0755 ftpsetup.sh ${D}/${sysconfdir}/scripts/ftpsetup.sh
}

FILES_${PN} += " \
	${sysconfdir}/scripts/ftpsetup.sh \
	"
