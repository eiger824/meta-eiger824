DESCRIPTION = "Simple script that generates private key and PEM certs for nginx"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

SRC_URI = " \
	file://certgen.sh \
	file://nginx.conf \
	"

RDEPENDS_${PN} += "bash"

do_install() {
	install -d -m 0755 ${D}/home/root
	install -m 0755 certgen.sh ${D}/home/root/certgen.sh 
	install -m 0644 nginx.conf ${D}/home/root/nginx.conf
}

FILES_${PN} += " \
		/home/root/certgen.sh \
		/home/root/nginx.conf \
		"
