export ARCHS = armv7 arm64 
export TARGET = :clang

include theos/makefiles/common.mk

BUNDLE_NAME = Convos
Convos_FILES = Convos.mm
Convos_INSTALL_PATH = /Library/PreferenceBundles
Convos_LIBRARIES = colorpicker 
Convos_FRAMEWORKS = MessageUI UIKit
Convos_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Convos.plist$(ECHO_END)
