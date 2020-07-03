# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RESTRICT="splitdebug"

sosicon_git_commit="655c75a4de75dbd4998ced6473aea255fed2492c"

DESCRIPTION="Converts a sosi file to a shapefile or to PostGIS"
HOMEPAGE="https://github.com/espena/sosicon/"
SRC_URI="
        https://github.com/espena/sosicon/archive/${sosicon_git_commit}.zip
"

SLOT="0/3.0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"

S="${WORKDIR}/sosicon-${sosicon_git_commit}/src"

src_prepare(){
	default

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths

		sed -i \
		-e "s|CC = g++|CC = "ccache g++|g" \
		-e "s|COMPILER_OPTS =|COMPILER_OPTS = ${CXXFLAGS}|g" \
		makefile || die
}

src_compile() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}"

}

src_install() {
	emake install prefix="${EPREFIX}/usr" DESTDIR="${D}"
}
