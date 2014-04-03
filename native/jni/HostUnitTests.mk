# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# HACK: Temporarily disable host tool build on Mac until the build system is ready for C++11.
LATINIME_HOST_OSNAME := $(shell uname -s)
ifneq ($(LATINIME_HOST_OSNAME), Darwin) # TODO: Remove this

LOCAL_PATH := $(call my-dir)

######################################
include $(CLEAR_VARS)

include $(LOCAL_PATH)/NativeFileList.mk

#################### Host library for unit test
# TODO: Remove -std=c++11 once it is set by default on host build.
LATIN_IME_SRC_DIR := src
LOCAL_CFLAGS += -std=c++11 -Wno-unused-parameter -Wno-unused-function
LOCAL_CLANG := true
LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(LATIN_IME_SRC_DIR)
LOCAL_IS_HOST_MODULE := true
LOCAL_MODULE := liblatinime_host_static_for_unittests
LOCAL_MODULE_TAGS := optional
LOCAL_NDK_STL_VARIANT := c++_static
LOCAL_SRC_FILES := $(addprefix $(LATIN_IME_SRC_DIR)/, $(LATIN_IME_CORE_SRC_FILES))
include $(BUILD_HOST_STATIC_LIBRARY)

#################### Host native tests
include $(CLEAR_VARS)
LATIN_IME_TEST_SRC_DIR := tests
# TODO: Remove -std=c++11 once it is set by default on host build.
LOCAL_CFLAGS += -std=c++11 -Wno-unused-parameter -Wno-unused-function
LOCAL_CLANG := true
LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(LATIN_IME_SRC_DIR)
LOCAL_IS_HOST_MODULE := true
LOCAL_MODULE := liblatinime_host_unittests
LOCAL_MODULE_TAGS := tests
LOCAL_NDK_STL_VARIANT := c++_static
LOCAL_SRC_FILES := $(addprefix $(LATIN_IME_TEST_SRC_DIR)/, $(LATIN_IME_CORE_TEST_FILES))
LOCAL_STATIC_LIBRARIES += liblatinime_host_static_for_unittests libgtest_host libgtest_main_host
include $(BUILD_HOST_NATIVE_TEST)

endif # Darwin - TODO: Remove this

#################### Clean up the tmp vars
LATINIME_HOST_OSNAME :=
LATIN_IME_SRC_DIR :=
LATIN_IME_TEST_SRC_DIR :=
include $(LOCAL_PATH)/CleanupNativeFileList.mk