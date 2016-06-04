################################################################################
#
# openpowerlink
#
################################################################################

OPENPOWERLINK_VERSION = V2.4.0
OPENPOWERLINK_SITE = http://downloads.sourceforge.net/project/openpowerlink/openPOWERLINK/$(OPENPOWERLINK_VERSION)
OPENPOWERLINK_SOURCE = openPOWERLINK_$(OPENPOWERLINK_VERSION).tar.gz
OPENPOWERLINK_LICENSE = BSD-2c, GPLv2
OPENPOWERLINK_LICENSE_FILES = license.md

OPENPOWERLINK_INSTALL_STAGING = YES

# The archive has no leading component.
OPENPOWERLINK_STRIP_COMPONENTS = 0

OPENPOWERLINK_MN_ONOFF = $(if $(BR2_PACKAGE_OPENPOWERLINK_MN),ON,OFF)
OPENPOWERLINK_CN_ONOFF = $(if $(BR2_PACKAGE_OPENPOWERLINK_CN),ON,OFF)

#### OPLK LIBRARY ####

# Always build a oplk stack
OPENPOWERLINK_CONF_OPTS += -DCFG_OPLK_LIB=ON

# All option are ON by default
ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_MONOLITHIC_USER_STACK_LIB),y)
OPENPOWERLINK_DEPENDENCIES += libpcap
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=OFF \
	-DCFG_COMPILE_LIB_CN=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=OFF
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_DEPENDENCIES += libpcap
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=OFF \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_CN=OFF \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=OFF \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=$(OPENPOWERLINK_CN_ONOFF)
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_LIB_MN=OFF \
	-DCFG_COMPILE_LIB_MNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_MNAPP_KERNELINTF=$(OPENPOWERLINK_MN_ONOFF) \
	-DCFG_COMPILE_LIB_MNAPP_PCIEINTF=OFF \
	-DCFG_COMPILE_LIB_MNDRV_PCAP=OFF \
	-DCFG_COMPILE_LIB_CN=OFF \
	-DCFG_COMPILE_LIB_CNAPP_USERINTF=OFF \
	-DCFG_COMPILE_LIB_CNAPP_KERNELINTF=$(OPENPOWERLINK_CN_ONOFF) \
	-DCFG_COMPILE_LIB_CNDRV_PCAP=OFF
endif

OPENPOWERLINK_CONF_OPTS += \
	-DCFG_COMPILE_SHARED_LIBRARY=$(if $(BR2_STATIC_LIBS),OFF,ON)

#### OPLK KERNEL DRIVERS ####

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_DEPENDENCIES += linux

OPENPOWERLINK_CONF_OPTS += \
	-DCFG_KERNEL_DRIVERS=ON \
	-DCFG_KERNEL_DIR="$(LINUX_DIR)" \
	-DCMAKE_SYSTEM_VERSION="$(LINUX_VERSION)" \
	-DCFG_OPLK_MN="$(OPENPOWERLINK_MN_ONOFF)" \
	-DMAKE_KERNEL_ARCH="$(KERNEL_ARCH)" \
	-DMAKE_KERNEL_CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)"

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_82573),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_POWERLINK_EDRV=82573
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_8255x),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_POWERLINK_EDRV=8255x
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_I210),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_POWERLINK_EDRV=i210
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_RTL8111),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_POWERLINK_EDRV=8111
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_KERNEL_DRIVER_RTL8139),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_POWERLINK_EDRV=8139
endif
endif

#### OPLK PCAP DAEMON ####

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_PCAP_DAEMON=ON \
	-DCFG_OPLK_MN=$(OPENPOWERLINK_MN_ONOFF)
endif

#### OPLK DEMO APPS ####

# See apps/common/cmake/configure-linux.cmake for available options list.
ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_MONOLITHIC_USER_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Link to Application"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_USERSPACE_DAEMON_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Linux Userspace Daemon"
else ifeq ($(BR2_PACKAGE_OPENPOWERLINK_STACK_KERNEL_STACK_LIB),y)
OPENPOWERLINK_CONF_OPTS += \
	-DCFG_BUILD_KERNEL_STACK="Linux Kernel Module"
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_DEMO_MN_CONSOLE),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_MN_CONSOLE=ON \
	-DCFG_DEMO_MN_CONSOLE_USE_SYNCTHREAD=ON
else
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_MN_CONSOLE=OFF
endif

ifeq ($(BR2_PACKAGE_OPENPOWERLINK_DEMO_CN_CONSOLE),y)
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_CN_CONSOLE=ON
else
OPENPOWERLINK_CONF_OPTS += -DCFG_DEMO_CN_CONSOLE=OFF
endif

$(eval $(cmake-package))
