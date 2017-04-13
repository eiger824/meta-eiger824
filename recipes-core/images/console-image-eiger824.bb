DESCRIPTION = "A core image based on jumpnowtek's qt5-image"
LICENSE = "MIT"

# We want our image to inherit ("require") from the already
# created image file qt5-image since it has everything needed

require ${HOME}/poky-morty/meta-rpi/images/qt5-image.bb

IMAGE_INSTALL += " \
	dummy \
	demotouch \
	mouseevents \
	fallingblocks \
	ftpsetup.sh \
	"

export IMAGE_BASENAME = "console-image-eiger824"
