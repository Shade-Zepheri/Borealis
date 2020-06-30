export TARGET = iphone:latest:13.0
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = Preferences

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Borealis
Borealis_FILES = $(wildcard *.[xm]) $(wildcard Extensions/*.[xm])
Borealis_FRAMEWORKS = Foundation QuartzCore UIKit
Borealis_EXTRA_FRAMEWORKS = Cephei
Borealis_LIBRARIES = palette
Borealis_CFLAGS = -IHeaders -IExtensions

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Preferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Borealis.plist$(ECHO_END)

after-install::
ifeq ($(RESPRING),0)
	install.exec "uiopen 'prefs:root=Borealis'"
else
	install.exec "sbreload"
endif