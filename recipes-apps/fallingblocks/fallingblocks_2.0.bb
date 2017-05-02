DESCRIPTION = "Falling blocks version for the raspberry pi 3"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

S = "${WORKDIR}/fallingblocks-${PV}"

PR = "r2"

SRC_URI = "git://github.com/eiger824/FallingBlocks.git;protocol=https;destsuffix=fallingblocks-${PV};branch=embedded"

SRCREV_pn-fallingblocks= "embedded"

inherit qmake5

do_install() {
	install -d -m 0755 ${D}/${bindir}/apps/fallingblocks
	install -m 0755 fallingblocks ${D}/${bindir}/apps/fallingblocks/fallingblocks
	install -d -m 0755 ${D}/${bindir}/apps/fallingblocks/images
	install -m 0755 ${S}/images/* ${D}/${bindir}/apps/fallingblocks/images/
}

FILES_${PN} += " \
	${bindir}/apps/fallingblocks/fallingblocks \
	${bindir}/apps/fallingblocks/images \
	"
