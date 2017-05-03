DESCRIPTION = "Simple login form"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

S = "${WORKDIR}/simplelogin-${PV}"

SRC_URI = "git://github.com/eiger824/simplelogin.git;protocol=https;destsuffix=simplelogin-${PV}"

SRCREV_pn-simplelogin = "master"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}/apps/simplelogin
	install -m 0755 simplelogin ${D}/${bindir}/apps/simplelogin/simplelogin
}

FILES_${PN} += " \
	${bindir}/apps/simplelogin/simplelogin \
	"

