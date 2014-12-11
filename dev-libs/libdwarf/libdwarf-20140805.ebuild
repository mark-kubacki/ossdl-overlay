# Copyright 2014 W. Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit flag-o-matic git-2

DESCRIPTION="library intended to simplify reading (and writing) applications using DWARF"
HOMEPAGE="http://reality.sgiweb.org/davea/dwarf.html"
SRC_URI=""

EGIT_REPO_URI="git://libdwarf.git.sourceforge.net/gitroot/libdwarf/libdwarf"
EGIT_COMMIT="${PV}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/dwarf-${PV}/${PN}/libdwarf

src_prepare() {
	replace-flags -O* -Os
	append-cflags -fPIC || die
}

src_configure() {
	econf --enable-shared $(use_enable static-libs nonshared)
}

src_install() {
	pushd libdwarf > /dev/null

	dolib.a libdwarf.a || die
	dolib.so libdwarf.so || die

	insinto /usr/include
	doins libdwarf.h || die

	dodoc NEWS README CHANGES || die

	popd > /dev/null
}
