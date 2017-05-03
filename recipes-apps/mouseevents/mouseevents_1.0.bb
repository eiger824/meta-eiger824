DESCRIPTION = "Mouse-test Qt5 app"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

S = "${WORKDIR}/mouseevents-${PV}"

PR = "r1"

SRC_URI = "git://github.com/eiger824/mouseevents.git;protocol=https;destsuffix=mouseevents-${PV}"

SRCREV_pn-mouseevents = "master"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}/apps/mouseevents
	install -m 0755 mouseevents ${D}/${bindir}/apps/mouseevents/mouseevents
}

FILES_${PN} += " \
	${bindir}/apps/mouseevents/mouseevents \
	"


