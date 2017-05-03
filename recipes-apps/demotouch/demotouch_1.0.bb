DESCRIPTION = "Test Qt5 app with QTimers, buttons and slider"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

S = "${WORKDIR}/demotouch-${PV}"

PR = "r1"

SRC_URI = "git://github.com/eiger824/demotouch.git;protocol=https;destsuffix=demotouch-${PV}"

SRCREV_pn-demotouch = "master"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}/apps/demotouch
	install -m 0755 demotouch ${D}/${bindir}/apps/demotouch/demotouch
}

FILES_${PN} += " \
	${bindir}/apps/demotouch/demotouch \
	"

