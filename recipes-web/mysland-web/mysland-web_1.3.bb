DESCRIPTION = "The webserver (nginx) 's files used in the rpi3"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

S = "${WORKDIR}"

PR = "r3"

SRC_URI = " \
	  file://home.html \
	  file://a.html \
	  file://b.html \
	  file://ftp.html \
	  "

do_install() {
	install -d -m 0755 ${D}/${localstatedir}/www/localhost/html
	install -m 0755 home.html ${D}/${localstatedir}/www/localhost/html/home.html
	install -m 0755 a.html ${D}/${localstatedir}/www/localhost/html/a.html
	install -m 0755 b.html ${D}/${localstatedir}/www/localhost/html/b.html
	install -m 0755 ftp.html ${D}/${localstatedir}/www/localhost/html/ftp.html
}

FILES_${PN} += " \
	${localstatedir}/www/localhost/html/home.html \
	${localstatedir}/www/localhost/html/a.html \
	${localstatedir}/www/localhost/html/b.html \
	${localstatedir}/www/localhost/html/ftp.html \
	"

