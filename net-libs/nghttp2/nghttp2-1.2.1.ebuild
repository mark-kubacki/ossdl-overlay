# Copyright 2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic autotools python-r1

DESCRIPTION="Implementation of Hypertext Transfer Protocol version 2 in C"
HOMEPAGE="https://nghttp2.org/"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tatsuhiro-t/${PN}.git
			git://github.com/tatsuhiro-t/${PN}.git"
	EGIT_MASTER="master"
	inherit git-2
else
	SRC_URI="https://github.com/tatsuhiro-t/${PN}/releases/download/v${PV}/${P}.tar.xz"
	RESTRICT="primaryuri"
fi

LICENSE="MIT"
SLOT="0/1.14" # <C++>.<C> SONAMEs - no longer the h2-xx version
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="alpn apps examples hpack-tools python spdy static-libs test xml"

REQUIRED_USE="xml? ( apps )
	alpn? ( apps )"
RDEPEND="!!net-misc/nghttp2
	apps? (
		dev-libs/jemalloc
		dev-libs/libev
		xml? ( >=dev-libs/libxml2-2.7.7 )
		>=dev-libs/openssl-1.0.1:=
		alpn? ( >=dev-libs/openssl-1.0.2_alpha:= )
		>=sys-libs/zlib-1.2.3
		>=dev-libs/jansson-2.5
	)
	hpack-tools? ( >=dev-libs/jansson-2.5 )
	spdy? ( net-misc/spdylay:= )
	python? (
		${PYTHON_DEPS}
		>=dev-python/cython-0.19
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		>=dev-util/cunit-2.1
	)"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	else
		default_src_prepare
	fi

	epatch_user

	replace-flags -O* -Os
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable hpack-tools) \
		$(use_enable static-libs static) \
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

src_install() {
	use static-libs || find "${ED}" -name '*.la' -delete
	default_src_install
}
