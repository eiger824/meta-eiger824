DESCRIPTION = "A core image based on jumpnowtek's qt5-image"
LICENSE = "MIT"

# We want our image to inherit ("require") from the already
# created image file qt5-image since it has everything needed

require ${HOME}/poky-morty/meta-rpi/images/qt5-image.bb

SPLASH = "psplash-eiger824"

IMAGE_INSTALL += " \
	dummy \
	apploader \
	demotouch \
	mouseevents \
	fallingblocks \
	ftpsetup \
	customenv \
	mysland-web \
	certgen \
	wlan-setup \
	tcp-server \
	"

export IMAGE_BASENAME = "console-image-eiger824"
