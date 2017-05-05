# Use our own nginx.conf instead of the default one
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://.htpasswd \
	file://mysland.key \
	file://mysland.pem \
	"

# Install our generated file and certificates to /etc/nginx dir
do_install_append() {
	install -m 0644 ${WORKDIR}/.htpasswd ${D}/${sysconfdir}/nginx/.htpasswd
	install -m 0644 ${WORKDIR}/mysland.key ${D}/${sysconfdir}/nginx/mysland.key
	install -m 0644 ${WORKDIR}/mysland.pem ${D}/${sysconfdir}/nginx/mysland.pem
}

# And ship our file
FILES_${PN} += " \
	${sysconfdir}/nginx/.htpasswd \
	${sysconfdir}/nginx/mysland.key \
	${sysconfdir}/nginx/mysland.pem \
	"

# Enable the service
pkg_postinst_${PN}() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
                if [ -n "$D" ]; then
                        OPTS="--root=$D"
                fi
                systemctl $OPTS enable nginx.service
        fi	
}
