DESCRIPTION = "A simple TCP server that receives commands from its counterpart client"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r5"

SRC_URI = " \
	file://rpi-tcp-server.c \
	file://strutils.h \
	file://Makefile \
	file://tcp-server.service \
	file://tcp-server-volatile.conf \
	"

TARGET_CC_ARCH += "${LDFLAGS}" 

do_compile() {
	${MAKE} rpi-tcp-server
}

do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d -m 0755 ${D}${sysconfdir}/tmpfiles.d
		echo "d /${localstatedir}/log/tcp-server 0755 root root -" \
			>> ${D}${sysconfdir}/tmpfiles.d/tcp-server.conf
	fi
	# binary
	install -d -m 0755 ${D}/${bindir}
	install -m 0755 rpi-tcp-server ${D}/${bindir}/rpi-tcp-server
	# logs
	install -d -m 0755 ${D}/${localstatedir}/log/tcp-server
	# volatile conf
	install -d -m 0755 ${D}/${sysconfdir}/default/volatiles
	install -m 0644 tcp-server-volatile.conf ${D}/${sysconfdir}/default/volatiles/99_tcp-server
	# systemd script
	install -d -m 0755 ${D}/${systemd_system_unitdir}
	install -m 0644 tcp-server.service ${D}/${systemd_system_unitdir}/tcp-server.service 
}

pkg_postinst_${PN} () {
        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
                if [ -n "$D" ]; then
                        OPTS="--root=$D"
		else
			if type systemd-tmpfiles >/dev/null; then
				systemd-tmpfiles --create
			elif [ -e ${sysconfdir}/init.d/populate-volatile.sh ]; then
				${sysconfdir}/init.d/populate-volatile.sh update
			fi
                fi
                systemctl $OPTS enable tcp-server.service
        fi
}

FILES_${PN} += " \
		rpi-tcp-server \
		${systemd_system_unitdir}/tcp-server.service \
		${localstatedir}/ \
		"


