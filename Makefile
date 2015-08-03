export PRODUCTS ?= $(abspath products)
export TMP ?= $(abspath tmp)


autoconf_src := $(shell find autoconf -type f \! -name .DS_Store)
autoconf_build_dir := $(TMP)/autoconf/build
autoconf_install_dir := $(TMP)/autoconf/install


.PHONY : all
all : $(PRODUCTS)/autoconf.pkg


.PHONY : clean
clean :
	-rm -f $(PRODUCTS)/autoconf.pkg
	-rm -rf $(TMP)


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


$(PRODUCTS) \
$(autoconf_build_dir) \
$(autoconf_install_dir) : 
	mkdir -p $@

