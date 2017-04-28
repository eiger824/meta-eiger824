# Change shell to bash
pkg_postinst_${PN}() {
	chsh -s /bin/bash
}

