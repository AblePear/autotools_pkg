export PRODUCTS ?= $(abspath products)
export TMP ?= $(abspath tmp)


.PHONY : all
all : $(PRODUCTS)/autoconf.pkg $(PRODUCTS)/automake.pkg


.PHONY : clean
clean :
	-rm -f $(PRODUCTS)/autoconf.pkg
	-rm -f $(PRODUCTS)/automake.pkg
	-rm -rf $(TMP)


##### autoconf #####

autoconf_src := $(shell find autoconf -type f \! -name .DS_Store)
autoconf_build_dir := $(TMP)/autoconf/build
autoconf_install_dir := $(TMP)/autoconf/install


$(PRODUCTS)/autoconf.pkg : $(autoconf_install_dir)/usr/local/bin/autoconf | $(PRODUCTS)
	pkgbuild \
        --root $(autoconf_install_dir) \
        --identifier com.ablepear.autoconf \
        --ownership recommended \
        $@


$(autoconf_install_dir)/usr/local/bin/autoconf : $(autoconf_build_dir)/bin/autoconf | $(autoconf_install_dir)
	cd $(autoconf_build_dir) && $(MAKE) DESTDIR=$(autoconf_install_dir) install


$(autoconf_build_dir)/bin/autoconf : $(autoconf_build_dir)/config.status $(autoconf_src)
	cd $(autoconf_build_dir) && $(MAKE)


$(autoconf_build_dir)/config.status : autoconf/configure | $(autoconf_build_dir)
	cd $(autoconf_build_dir) && sh $(abspath autoconf/configure)


##### automake #####

automake_src := $(shell find automake -type f \! -name .DS_Store)
automake_build_dir := $(TMP)/automake/build
automake_install_dir := $(TMP)/automake/install


$(PRODUCTS)/automake.pkg : $(automake_install_dir)/usr/local/bin/automake | $(PRODUCTS)
	pkgbuild \
        --root $(automake_install_dir) \
        --identifier com.ablepear.automake \
        --ownership recommended \
        $@


$(automake_install_dir)/usr/local/bin/automake : $(automake_build_dir)/bin/automake | $(automake_install_dir)
	cd $(automake_build_dir) && $(MAKE) DESTDIR=$(automake_install_dir) install


$(automake_build_dir)/bin/automake : $(automake_build_dir)/config.status $(automake_src)
	cd $(automake_build_dir) && $(MAKE)


$(automake_build_dir)/config.status : automake/configure | $(automake_build_dir)
	cd $(automake_build_dir) && sh $(abspath automake/configure)


##### directories #####

$(PRODUCTS) \
$(autoconf_build_dir) \
$(autoconf_install_dir) \
$(automake_build_dir) \
$(automake_install_dir) : 
	mkdir -p $@

