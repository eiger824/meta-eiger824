DESCRIPTION = "Custom .bashrc and .qtenv files"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR="r1"

SRC_URI = " \
	   file://.qtenv \
	   file://.bashrc \
	   "

do_install() {
	install -d -m 0644 ${D}/home/root
	install -m 0644 .bashrc ${D}/home/root/.bashrc
	install -m 0644 .qtenv ${D}/home/root/.qtenv
}

FILES_${PN} += " \
		/home/root/.qtenv \
		/home/root/.bashrc \
		"	
