DESCRIPTION = "Falling blocks version for the raspberry pi 3"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

S = "${WORKDIR}/fallingblocks-${PV}"

SRC_URI = "git://github.com/eiger824/FallingBlocks.git;protocol=https;destsuffix=fallingblocks-${PV};branch=embedded"

SRCREV_pn-fallingblocks= "embedded"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}
	install -m 0755 fallingblocks ${D}/${bindir}/fallingblocks
}

