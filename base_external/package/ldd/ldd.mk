LDD_VERSION = 66ae044f7f2747289cc82d9862aba9d57e11e714
LDD_SITE = 'git@github.com:cu-ecen-aeld/assignment-7-IagoErrera.git'
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES
LDD_MODULE_SUBDIRS = misc-modules scull

define LDD_BUILD_TARGET_CMDS
	$(foreach dir,$(LDD_MODULE_SUBDIRS),
        $(MAKE) -C "$(@D)/$(dir)" $(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR)
    )
endef

define LDD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 664 $(@D)/scull/scull.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/scull.ko
	$(INSTALL) -D -m 664 $(@D)/misc-modules/faulty.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/faulty.ko
	$(INSTALL) -D -m 664 $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/hello.ko
endef

define LDD_FIX_PERMS
	chmod +x $(TARGET_DIR)/etc/init.d/S98lddmodules
endef

ROOTFS_POST_BUILD_HOOKS += LDD_FIX_PERMS
$(eval $(kernel-module))
$(eval $(generic-package))
