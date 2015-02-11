# Copyright 2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="data compression library providing in-memory LZMA compression and decompression functions"
HOMEPAGE="http://lzip.nongnu.org/lzlib.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="app-arch/lzip"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
