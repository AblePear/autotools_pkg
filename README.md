GNU Autotools for macOS
=======================

This project builds a standard macOS installer package for Autotools, the GNU
build system. It contains the source distributions for [Autoconf 2.69][1], 
[Automake 1.15][2], and [Libtool 2.4.6][3]


Dependencies
------------
This release was built on macOS 10.11.5 with Xcode 7.3.1 installed. Building
Automake requires a recent version version of Autoconf; if you don't have
Autoconf, you can download the [prebuilt installer][4] or first run:

    make autoconf

then run the unsigned `autoconf-<version>.pkg` installer package located in the
project `tmp` directory.


License
-------
The installer and related scripts are copyright (c) 2016 Able Pear Software.
Autotools and the installer are distributed under the GNU General Public 
License, version 2. See the LICENSE file for details.

[1]: https://www.gnu.org/software/autoconf/autoconf.html "Autoconf"
[2]: https://www.gnu.org/software/automake/automake.html "Automake"
[3]: https://www.gnu.org/software/libtool/libtool.html "Libtool"
[4]: https://github.com/AblePear/autotools_pkg/releases "Autotools Releases"
