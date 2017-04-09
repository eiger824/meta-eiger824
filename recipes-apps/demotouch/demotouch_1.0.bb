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

SRC_URI[md5sum] = "d872ed2ecb4dd1f6489767aee43c56a5"
SRC_URI[sha256sum] = "0b488393f065d92e0990e59a41aa780b3aa455d6501398a504b4545d7f971d25"
