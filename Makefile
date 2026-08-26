ARCHS = arm64
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AntiBurn
AntiBurn_FILES = AntiBurn.m
AntiBurn_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk