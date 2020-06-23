ARCHS =  arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Actify

Actify_FILES = Listener.x
Actify_LIBRARIES = activator
Actify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += ActifyPreferences ActifyTool
include $(THEOS_MAKE_PATH)/aggregate.mk