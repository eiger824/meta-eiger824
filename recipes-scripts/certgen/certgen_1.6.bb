DESCRIPTION = "Simple script that generates private key and PEM certs for nginx"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r5"

SRC_URI = " \
	file://certgen.sh \
	"

RDEPENDS_${PN} += "bash"

do_install() {
	install -d -m 0755 ${D}/${sysconfdir}/scripts
	install -m 0755 certgen.sh ${D}/${sysconfdir}/scripts/certgen.sh 
}

FILES_${PN} += " \
	${sysconfdir}/scripts/certgen.sh \
	"


