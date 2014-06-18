# Copyright 2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit eutils autotools

DESCRIPTION="Implementation of Google’s SPDY protocol in C"
HOMEPAGE="http://tatsuhiro-t.github.io/spdylay/index.html"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tatsuhiro-t/${PN}.git
			git://github.com/tatsuhiro-t/${PN}.git"
	EGIT_MASTER="master"
	inherit git-2
else
	SRC_URI="https://github.com/tatsuhiro-t/${PN}/releases/download/v${PV}/${P}.tar.xz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
# examples are always built

RDEPEND=">=dev-libs/openssl-1.0.1
	>=dev-libs/libevent-2.0.8[ssl]
	>=dev-libs/libxml2-2.7.7
	>=sys-libs/zlib-1.2.3"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.28
	test? (
		=dev-lang/python-2*
		>=dev-util/cunit-2.1
	)"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	else
		default_src_prepare
	fi
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-examples
}

src_test() {
	# tests can be parallelised, using emake
	emake check || die "test failed"
}
