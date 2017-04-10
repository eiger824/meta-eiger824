DESCRIPTION = "Test Qt5 app with QTimers, buttons and slider"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

SRC_URI = "https://github.com/eiger824/demotouch.git;protocol=https"

SRCREV_pn-demotouch = "master"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}
	install -m 0755 demotouch ${D}/${bindir}/demotouch
}

SRC_URI[md5sum] = "???"
SRC_URI[sha256sum] = "???"
