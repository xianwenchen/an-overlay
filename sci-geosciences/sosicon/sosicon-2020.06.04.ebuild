# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# "inherit toolchain-funcs" is necessary, so that "tc-*" functions are useful.
inherit toolchain-funcs

RESTRICT="splitdebug"

sosicon_git_commit="655c75a4de75dbd4998ced6473aea255fed2492c"

DESCRIPTION="Converts a sosi file to a shapefile or to PostGIS"
HOMEPAGE="https://github.com/espena/sosicon/"
SRC_URI="
        https://github.com/espena/sosicon/archive/${sosicon_git_commit}.zip
"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"

S="${WORKDIR}/sosicon-${sosicon_git_commit}/src"

src_prepare(){
	default

	mv makefile Makefile

	sed -i "s|INSTALL_PATH ?= /usr/local|INSTALL_PATH = ${D}|g" Makefile || die
	sed -i "s|COMPILER_OPTS =|COMPILER_OPTS = ${CXXFLAGS}|g" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCXX)" prefix="${EPREFIX}/usr" DESTDIR="${D}"

}

src_install() {
	mkdir ${D}/bin
	emake install prefix="${EPREFIX}/usr" DESTDIR="${D}"
	# The Makefile does not honor "prefix=".
	# I am fixing it manually now.
	mkdir ${D}/usr
	mv ${D}/bin ${D}/usr
}
