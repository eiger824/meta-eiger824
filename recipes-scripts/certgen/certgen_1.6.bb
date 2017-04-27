DESCRIPTION = "Simple script that generates private key and PEM certs for nginx"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r4"

SRC_URI = " \
	file://certgen.sh \
	"

RDEPENDS_${PN} += "bash"

do_install() {
	install -d -m 0755 ${D}/${sysconfdir}
	install -m 0755 certgen.sh ${D}/${sysconfdir}/certgen.sh 
}

