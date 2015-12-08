export ARCHS = armv7 arm64 
export TARGET = :clang

include theos/makefiles/common.mk

TWEAK_NAME = Convos
Convos_FILES = Tweak.xm BDSettingsManager.m HexColors/HexColors.m Toast/UIView+Toast.m
Convos_FRAMEWORKS = CoreGraphics Foundation QuartzCore UIKit
Convos_PRIVATE_FRAMEWORKS = ChatKit
Convos_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS; killall Preferences"
SUBPROJECTS += convos
include $(THEOS_MAKE_PATH)/aggregate.mk
