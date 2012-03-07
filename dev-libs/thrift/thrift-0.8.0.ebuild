# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI="3"
WANT_AUTOCONF="latest"
inherit autotools flag-o-matic

DESCRIPTION="Data serialization and communication toolwork"
HOMEPAGE="http://thrift.apache.org/about/"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="+pic cpp c_glib csharp java erlang python perl php php_extension ruby haskell go"

RDEPEND=">=dev-libs/boost-1.34.0
	virtual/yacc
	sys-devel/flex
	dev-libs/openssl
	cpp? (
		>=sys-libs/zlib-1.2.3
		dev-libs/libevent
	)
	csharp? ( >=dev-lang/mono-1.2.4 )
	java? (
		>=virtual/jdk-1.5
		dev-java/ant
		dev-java/ant-ivy
		dev-java/commons-lang
		dev-java/slf4j-api
	)
	erlang? ( >=dev-lang/erlang-12.0.0 )
	python? (
		>=dev-lang/python-2.4.0
		!dev-python/thrift
	)
	perl? (
		dev-lang/perl
		dev-perl/Bit-Vector
		dev-perl/Class-Accessor
	)
	php? ( >=dev-lang/php-5.0.0 )
	php_extension? ( >=dev-lang/php-5.0.0 )
	ruby? ( virtual/rubygems )
	haskell? ( dev-haskell/haskell-platform )
	go? ( sys-devel/gcc[go] )
	"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-3.3.5
	c_glib? ( dev-libs/glib )
	"

S="${WORKDIR}/${P/_beta[0-9]/}"

src_configure() {
	local myconf
	for USEFLAG in ${IUSE}; do
		myconf+=" $(use_with ${USEFLAG/+/})"
	done

	# This flags either result in compilation errors
	# or byzantine runtime behaviour.
	filter-flags -fwhole-program -fwhopr

	econf \
		${myconf}
}

src_compile() {
	if use cpp; then
		# -jx fails for x > 1 with use cpp
		emake -j1 || die "emake install failed"
	else
		emake || die "emake install failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
