LOCAL_PATH := $(call my-dir)

LOCAL_MODULE := dragonbones_static

LOCAL_MODULE_FILENAME := libdragonbones

LOCAL_SRC_FILES := \
	$(wildcard $(LOCAL_PATH)/*.cpp) \
	$(wildcard $(LOCAL_PATH)/animation/*.cpp) \
	$(wildcard $(LOCAL_PATH)/core/*.cpp) \
	$(wildcard $(LOCAL_PATH)/display/*.cpp) \
	$(wildcard $(LOCAL_PATH)/events/*.cpp) \
	$(wildcard $(LOCAL_PATH)/factories/*.cpp) \
	$(wildcard $(LOCAL_PATH)/objects/*.cpp) \
	$(wildcard $(LOCAL_PATH)/textures/*.cpp) \
	$(wildcard $(LOCAL_PATH)/utils/*.cpp) \

# TODO(hejiangzhou): Shall we disable exception?
LOCAL_CPPFLAGS := -fexceptions -std=c++11

LOCAL_EXPORT_CPPFLAGS := -fexceptions -std=c++11

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH) \
                    $(LOCAL_PATH)/animation \
                    $(LOCAL_PATH)/core \
                    $(LOCAL_PATH)/display \
                    $(LOCAL_PATH)/events \
                    $(LOCAL_PATH)/factories \
                    $(LOCAL_PATH)/objects \
                    $(LOCAL_PATH)/textures \
                    $(LOCAL_PATH)/utils

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
                    $(LOCAL_PATH)/animation \
                    $(LOCAL_PATH)/core \
                    $(LOCAL_PATH)/display \
                    $(LOCAL_PATH)/events \
                    $(LOCAL_PATH)/factories \
                    $(LOCAL_PATH)/objects \
                    $(LOCAL_PATH)/textures \
                    $(LOCAL_PATH)/utils

NDK_TOOLCHAIN_VERSION := 4.8


LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static

$(call import-module,cocos2dx)
$(call import-module,scripting/lua/proj.android)

include $(BUILD_STATIC_LIBRARY)
