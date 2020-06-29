export TARGET = iphone:latest:13.0
export ARCHS = arm64 arm64e

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Borealis
Borealis_FILES = $(wildcard *.[xm])
Borealis_FRAMEWORKS = Foundation QuartzCore UIKit
Borealis_CFLAGS = -IHeaders

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"