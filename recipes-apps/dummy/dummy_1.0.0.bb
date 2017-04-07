DESCRIPTION = "A dummy c file that calls you by your name"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

SRC_URI = "file://dummy.c"

do_compile() {
	${MAKE} dummy
}

do_install() {
	install -d -m 0755 ${D}/${bindir}
	install -m 0755 dummy ${D}/${bindir}/dummy
}
