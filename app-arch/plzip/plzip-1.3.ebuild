# Copyright 2013-2015 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="parallel lossless data compressor based on the lzlib compression library"
HOMEPAGE="http://lzip.nongnu.org/plzip.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="dev-libs/lzlib"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
