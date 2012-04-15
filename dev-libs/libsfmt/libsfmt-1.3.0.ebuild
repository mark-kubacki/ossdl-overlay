# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI="3"

DESCRIPTION="Implementation of the SIMD-oriented Fast Mersenne Twister"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index.html"
SRC_URI="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/VERSIONS/ARCHIVES/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	"
DEPEND="${RDEPEND}
	"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
