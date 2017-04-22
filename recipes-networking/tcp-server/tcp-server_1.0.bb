DESCRIPTION = "A simple TCP server that receives commands from its counterpart client"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = " \
	file://rpi-tcp-server.c \
	file://Makefile \
	file://rpi-tcp-server.service \
	"

TARGET_CC_ARCH += "${LDFLAGS}" 

do_compile() {
	echo "MAKE IS ${MAKE}"
	${MAKE} rpi-tcp-server
}

do_install() {
	# binary
	install -d -m 0755 ${D}/${bindir}
	install -m 0755 rpi-tcp-server ${D}/${bindir}/rpi-tcp-server
	# logs
	install -d -m 0644 ${D}/${localstatedir}/log/rpi-tcp-server
	# systemd script
	install -d -m 0755 ${D}/${systemd_system_unitdir}
	install -m 0644 rpi-tcp-server.service ${D}/${systemd_system_unitdir}/rpi-tcp-server.service 
}

FILES_${PN} += " \
		rpi-tcp-server \
		${systemd_system_unitdir}/rpi-tcp-server.service \
		"

pkg_postinst_${PN} () {
        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
                if [ -n "$D" ]; then
                        OPTS="--root=$D"
                fi
                systemctl $OPTS enable rpi-tcp-server.service
        fi
}
