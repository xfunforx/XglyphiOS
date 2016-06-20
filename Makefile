include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ingressXglyph
ingressXglyph_FILES = Tweak.xm
ingressXglyph_FRAMEWORKS = Foundation UIKit CoreFoundation CoreGraphics MobileCoreServices
include $(THEOS_MAKE_PATH)/tweak.mk
service_CFLAGS += -std=c99
after-install::
	install.exec "killall -9 SpringBoard"
