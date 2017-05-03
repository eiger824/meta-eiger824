# Use our own nginx.conf instead of the default one
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://.htpasswd \
	"

# Install our generated file to /etc/nginx dir
do_install_append() {
	install -m 0755 ${WORKDIR}/.htpasswd ${D}/${sysconfdir}/nginx/.htpasswd
}

# And ship our file
FILES_${PN} += " \
	${sysconfdir}/nginx/.htpasswd \
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
