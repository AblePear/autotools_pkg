export PRODUCTS ?= $(abspath products)
export TMP ?= $(abspath tmp)


.PHONY : all
all : $(PRODUCTS)/autoconf.pkg $(PRODUCTS)/automake.pkg $(PRODUCTS)/libtool.pkg


.PHONY : clean
clean :
	-rm -f $(PRODUCTS)/autoconf.pkg
	-rm -f $(PRODUCTS)/automake.pkg
	-rm -f $(PRODUCTS)/libtool.pkg
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


##### libtool #####

libtool_src := $(shell find libtool -type f \! -name .DS_Store)
libtool_build_dir := $(TMP)/libtool/build
libtool_install_dir := $(TMP)/libtool/install


$(PRODUCTS)/libtool.pkg : $(libtool_install_dir)/usr/local/bin/libtool | $(PRODUCTS)
	pkgbuild \
        --root $(libtool_install_dir) \
        --identifier com.ablepear.libtool \
        --ownership recommended \
        $@


$(libtool_install_dir)/usr/local/bin/libtool : $(libtool_build_dir)/libtool | $(libtool_install_dir)
	cd $(libtool_build_dir) && $(MAKE) DESTDIR=$(libtool_install_dir) install


$(libtool_build_dir)/libtool : $(libtool_build_dir)/config.status $(libtool_src)
	cd $(libtool_build_dir) && $(MAKE)


$(libtool_build_dir)/config.status : libtool/configure | $(libtool_build_dir)
	cd $(libtool_build_dir) && sh $(abspath libtool/configure)


##### directories #####

$(PRODUCTS) \
$(autoconf_build_dir) \
$(autoconf_install_dir) \
$(automake_build_dir) \
$(automake_install_dir) \
$(libtool_build_dir) \
$(libtool_install_dir) : 
	mkdir -p $@

