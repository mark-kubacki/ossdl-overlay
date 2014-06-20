# Copyright 2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit eutils autotools

DESCRIPTION="Implementation of Hypertext Transfer Protocol version 2 in C"
HOMEPAGE="https://nghttp2.org/"
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
IUSE="+alpn +apps +examples python +spdy +xml"

REQUIRED_USE="xml? ( apps )
	alpn? ( apps )"
RDEPEND=">=dev-libs/jansson-2.5
	apps? (
		dev-libs/jemalloc
		>=dev-libs/libevent-2.0.8[ssl]
		xml? ( >=dev-libs/libxml2-2.7.7 )
		>=dev-libs/openssl-1.0.1
		alpn? ( >=dev-libs/openssl-1.0.2_alpha )
		>=sys-libs/zlib-1.2.3
	)
	spdy? ( net-misc/spdylay )
	python? (
		=dev-lang/python-2*
		>=dev-python/cython-0.19
	)"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20
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
		$(use_enable apps app) $(use_with apps jemalloc) \
		$(use_enable examples) \
		$(use_enable python python-bindings) \
		$(use_with spdy spdylay) \
		$(use_with xml libxml2) $(use !xml && echo --disable-xmltest --without-libxml2)
}

src_test() {
	# tests can be parallelised, using emake
	emake check || die "test failed"
}
