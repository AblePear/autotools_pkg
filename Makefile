TMP ?= $(abspath tmp)

autoconf_version := 2.69
automake_version := 1.15
libtool_version := 2.4.6
installer_version := 4

.SECONDEXPANSION :

.PHONY : all
all : autotools-r$(installer_version).pkg

.PHONY : autoconf
autoconf : $(TMP)/autoconf-$(autoconf_version).pkg

.PHONY : automake
automake : $(TMP)/automake-$(automake_version).pkg

.PHONY : libtool
libtool : $(TMP)/libtool-$(libtool_version).pkg

.PHONY : clean
clean :
	-rm -f autotools-r*.pkg
	-rm -rf $(TMP)


#### product #####

autotools-r$(installer_version).pkg : \
        $(TMP)/autoconf-$(autoconf_version).pkg \
        $(TMP)/automake-$(automake_version).pkg \
        $(TMP)/libtool-$(libtool_version).pkg \
        $(TMP)/distribution.xml \
        $(TMP)/resources/background.png \
        $(TMP)/resources/license.html \
        $(TMP)/resources/welcome.html
	productbuild \
        --distribution $(TMP)/distribution.xml \
        --resources $(TMP)/resources \
        --package-path $(TMP) \
        --version $(installer_version) \
        --sign 'Able Pear Software Incorporated' \
        $@

$(TMP)/distribution.xml \
$(TMP)/resources/welcome.html : $(TMP)/% : % | $$(dir $$@)
	sed \
        -e s/{{autoconf_version}}/$(autoconf_version)/g \
        -e s/{{automake_version}}/$(automake_version)/g \
        -e s/{{libtool_version}}/$(libtool_version)/g \
        -e s/{{installer_version}}/$(installer_version)/g \
        $< > $@

$(TMP)/resources/background.png \
$(TMP)/resources/license.html : $(TMP)/% : % | $(TMP)/resources
	cp $< $@

$(TMP) \
$(TMP)/resources :
	mkdir -p $@


##### autoconf pkg #####
autoconf_sources := $(shell find autoconf -type f \! -name .DS_Store)

$(TMP)/autoconf-$(autoconf_version).pkg : \
        $(TMP)/autoconf/install/usr/local/bin/autoconf \
        $(TMP)/autoconf/install/etc/paths.d/autoconf.path
	pkgbuild \
        --root $(TMP)/autoconf/install \
        --identifier com.ablepear.autoconf \
        --ownership recommended \
        --version $(autoconf_version) \
        $@

$(TMP)/autoconf/install/etc/paths.d/autoconf.path : autotools.path | $(TMP)/autoconf/install/etc/paths.d
	cp $< $@

$(TMP)/autoconf/install/usr/local/bin/autoconf : $(TMP)/autoconf/build/bin/autoconf | $(TMP)/autoconf/install
	cd $(TMP)/autoconf/build && $(MAKE) DESTDIR=$(TMP)/autoconf/install install

$(TMP)/autoconf/build/bin/autoconf : $(TMP)/autoconf/build/config.status $(autoconf_sources)
	cd $(TMP)/autoconf/build && $(MAKE)

$(TMP)/autoconf/build/config.status : autoconf/configure | $(TMP)/autoconf/build
	cd $(TMP)/autoconf/build && sh $(abspath autoconf/configure)

$(TMP)/autoconf/build \
$(TMP)/autoconf/install \
$(TMP)/autoconf/install/etc/paths.d :
	mkdir -p $@

##### automake pkg #####
automake_sources := $(shell find automake -type f \! -name .DS_Store)

$(TMP)/automake-$(automake_version).pkg : \
        $(TMP)/automake/install/usr/local/bin/automake \
        $(TMP)/automake/install/etc/paths.d/automake.path
	pkgbuild \
        --root $(TMP)/automake/install \
        --identifier com.ablepear.automake \
        --ownership recommended \
        --version $(automake_version) \
        $@

$(TMP)/automake/install/etc/paths.d/automake.path : autotools.path | $(TMP)/automake/install/etc/paths.d
	cp $< $@

$(TMP)/automake/install/usr/local/bin/automake : $(TMP)/automake/build/bin/automake | $(TMP)/automake/install
	cd $(TMP)/automake/build && $(MAKE) DESTDIR=$(TMP)/automake/install install

$(TMP)/automake/build/bin/automake : $(TMP)/automake/build/config.status $(automake_sources)
	cd $(TMP)/automake/build && $(MAKE)

$(TMP)/automake/build/config.status : automake/configure | $(TMP)/automake/build
	cd $(TMP)/automake/build && sh $(abspath automake/configure)

$(TMP)/automake/build \
$(TMP)/automake/install \
$(TMP)/automake/install/etc/paths.d :
	mkdir -p $@


##### libtool pkg #####
libtool_sources := $(shell find libtool -type f \! -name .DS_Store)

$(TMP)/libtool-$(libtool_version).pkg : \
        $(TMP)/libtool/install/usr/local/bin/libtool \
        $(TMP)/libtool/install/etc/paths.d/libtool.path
	pkgbuild \
        --root $(TMP)/libtool/install \
        --identifier com.ablepear.libtool \
        --ownership recommended \
        --version $(libtool_version) \
        $@

$(TMP)/libtool/install/etc/paths.d/libtool.path : autotools.path | $(TMP)/libtool/install/etc/paths.d
	cp $< $@

$(TMP)/libtool/install/usr/local/bin/libtool : $(TMP)/libtool/build/libtool | $(TMP)/libtool/install
	cd $(TMP)/libtool/build && $(MAKE) DESTDIR=$(TMP)/libtool/install install

$(TMP)/libtool/build/libtool : $(TMP)/libtool/build/config.status $(libtool_sources)
	cd $(TMP)/libtool/build && $(MAKE)

$(TMP)/libtool/build/config.status : libtool/configure | $(TMP)/libtool/build
	cd $(TMP)/libtool/build && sh $(abspath libtool/configure)

$(TMP)/libtool/build \
$(TMP)/libtool/install \
$(TMP)/libtool/install/etc/paths.d :
	mkdir -p $@

