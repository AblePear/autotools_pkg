TMP ?= $(abspath tmp)
pkg_version := 1
autoconf_version := 2.69
automake_version := 1.15
libtool_version := 2.4.6


.PHONY : all
all : autotools.pkg


.PHONY : clean
clean :
	-rm -f autotools.pkg
	-rm -rf $(TMP)


#### autotools.pkg #####

autotools.pkg : \
        $(TMP)/autoconf.pkg \
        $(TMP)/automake.pkg \
        $(TMP)/libtool.pkg \
        resources/background.png \
        resources/distribution.xml \
        resources/license.html \
        resources/welcome.html
	productbuild \
        --distribution resources/distribution.xml \
        --resources resources \
        --package-path $(TMP) \
        --version $(pkg_version) \
        --sign 'Able Pear Software Incorporated' \
        $@


##### autoconf #####

autoconf_src := $(shell find autoconf -type f \! -name .DS_Store)
autoconf_build_dir := $(TMP)/autoconf/build
autoconf_install_dir := $(TMP)/autoconf/install


$(TMP)/autoconf.pkg : $(autoconf_install_dir)/usr/local/bin/autoconf | $(TMP)
	pkgbuild \
        --root $(autoconf_install_dir) \
        --identifier com.ablepear.autoconf \
        --ownership recommended \
        --version $(autoconf_version) \
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


$(TMP)/automake.pkg : $(automake_install_dir)/usr/local/bin/automake | $(TMP)
	pkgbuild \
        --root $(automake_install_dir) \
        --identifier com.ablepear.automake \
        --ownership recommended \
        --version $(automake_version) \
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


$(TMP)/libtool.pkg : $(libtool_install_dir)/usr/local/bin/libtool | $(TMP)
	pkgbuild \
        --root $(libtool_install_dir) \
        --identifier com.ablepear.libtool \
        --ownership recommended \
        --version $(libtool_version) \
        $@


$(libtool_install_dir)/usr/local/bin/libtool : $(libtool_build_dir)/libtool | $(libtool_install_dir)
	cd $(libtool_build_dir) && $(MAKE) DESTDIR=$(libtool_install_dir) install


$(libtool_build_dir)/libtool : $(libtool_build_dir)/config.status $(libtool_src)
	cd $(libtool_build_dir) && $(MAKE)


$(libtool_build_dir)/config.status : libtool/configure | $(libtool_build_dir)
	cd $(libtool_build_dir) && sh $(abspath libtool/configure)


##### directories #####

$(TMP) \
$(autoconf_build_dir) \
$(autoconf_install_dir) \
$(automake_build_dir) \
$(automake_install_dir) \
$(libtool_build_dir) \
$(libtool_install_dir) : 
	mkdir -p $@

