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

src_prepare(){
	default

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths

	sed -i \
		-e "s|COMPILER_OPTS =|COMPILER_OPTS = ${CXXFLAGS}|g" \
		sosicon-${sosicon_git_commit}/src/makefile || die
}

src_compile() {
	cd sosicon-${sosicon_git_commit}/src
	emake
		prefix="${EPREFIX}/usr" DESTDIR="${D}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
        cd sosicon-${sosicon_git_commit}/src
	emake install \
		prefix="${EPREFIX}/usr" DESTDIR="${D}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}
