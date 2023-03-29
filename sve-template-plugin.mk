######################################
#
# sve-template-plugin bundle
#
######################################

# where to find the source code - locally in this case
SVE_TEMPLATE_PLUGIN_SITE_METHOD = local
SVE_TEMPLATE_PLUGIN_SITE = $($(PKG)_PKGDIR)/

# even though this is a local build, we still need a version number
# bump this number if you need to force a rebuild
SVE_TEMPLATE_PLUGIN_VERSION = 1.0

# dependencies (list of other buildroot packages, separated by space)
# on this package we need to depend on the host version of ourselves to be able to run the ttl generator
SVE_TEMPLATE_PLUGIN_DEPENDENCIES = host-sve-template-plugin

# LV2 bundles that this package generates (space separated list)
SVE_TEMPLATE_PLUGIN_BUNDLES = sve-template-plugin.lv2

# call make with the current arguments and path. "$(@D)" is the build directory.
SVE_TEMPLATE_PLUGIN_HOST_MAKE   = $(HOST_MAKE_ENV)   $(HOST_CONFIGURE_OPTS)   $(MAKE_CLEAN) $(MAKE) -C $(@D)/source
SVE_TEMPLATE_PLUGIN_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE_CLEAN) $(MAKE) -C $(@D)/source

# temp dir where we place the generated ttls
SVE_TEMPLATE_PLUGIN_TMP_DIR = $(HOST_DIR)/tmp-sve-template-plugin

# build plugins in host to generate ttls
define HOST_SVE_TEMPLATE_PLUGIN_BUILD_CMDS
	# build everything
	$(SVE_TEMPLATE_PLUGIN_HOST_MAKE)

	# delete binaries
	rm $(@D)/source/build/*.lv2/*.so

	# create temp dir
	rm -rf $(SVE_TEMPLATE_PLUGIN_TMP_DIR)
	mkdir -p $(SVE_TEMPLATE_PLUGIN_TMP_DIR)

	# copy the generated bundles without binaries to temp dir
	cp -r $(@D)/source/build/*.lv2 $(SVE_TEMPLATE_PLUGIN_TMP_DIR)
endef

# build plugins in target skipping ttl generation
define SVE_TEMPLATE_PLUGIN_BUILD_CMDS
	# create dummy generator
	mkdir -p $(@D)/source/build
	touch $(@D)/source/build/lv2_ttl_generator
	chmod +x $(@D)/source/build/lv2_ttl_generator

	# now build in target
	$(SVE_TEMPLATE_PLUGIN_TARGET_MAKE)

	# cleanup
	rm $(@D)/source/build/lv2_ttl_generator
endef

# install command
define SVE_TEMPLATE_PLUGIN_INSTALL_TARGET_CMDS
	$(SVE_TEMPLATE_PLUGIN_TARGET_MAKE) install DESTDIR=$(TARGET_DIR)
endef


# import everything else from the buildroot generic package
$(eval $(generic-package))
# import host version too
$(eval $(host-generic-package))
