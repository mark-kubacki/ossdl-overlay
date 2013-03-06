# Copyright 2012-2013 W-Mark Kubacki, Vitaly Repin
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
inherit autotools eutils git-2 flag-o-matic autotools

LIBTOOL_PV="2.4"

DESCRIPTION="Data serialization and communication toolwork"
HOMEPAGE="http://thrift.apache.org/about/"
EGIT_REPO_URI="http://git-wip-us.apache.org/repos/asf/thrift.git"
SRC_URI="mirror://gnu/libtool/libtool-${LIBTOOL_PV}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+pic cpp c_glib csharp java erlang python perl php php_extension ruby haskell go"

RDEPEND=">=dev-libs/boost-1.40.0
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
		>=dev-lang/python-2.6.0
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
	>=sys-devel/gcc-4.2[cxx]
	c_glib? ( dev-libs/glib )
	"

S="${WORKDIR}/${P/_beta[0-9]/}"
S_LIBTOOL="${WORKDIR}/libtool-${LIBTOOL_PV}"
LIBTOOL_D="${WORKDIR}/local/usr"

src_unpack() {
	git-2_src_unpack
	unpack ${A}
}

src_prepare() {
	# this is for the specific libtool version which thrift relies on
	cd "$S_LIBTOOL"
	econf --disable-static --prefix="$LIBTOOL_D"
	emake
	emake DESTDIR="$LIBTOOL_D" install
	LIBTOOL_REAL_D=$(dirname $(find "$LIBTOOL_D" -name 'libtoolize' | head -n 1))
	mv "${LIBTOOL_REAL_D}"/../include "${LIBTOOL_REAL_D}"/../lib* "${LIBTOOL_REAL_D}" "${LIBTOOL_D}/"
	mv "${LIBTOOL_D}"/usr/* "${LIBTOOL_D}"/
	rm -r "${LIBTOOL_D}"/usr "${LIBTOOL_D}"/tmp
	sed -i	-e "s:/usr/share:${LIBTOOL_D}/share:g" "${LIBTOOL_D}"/bin/libtoolize

	# now comes thrift
	cd "$S"
	PATH="${LIBTOOL_D}/bin:${PATH}" sh bootstrap.sh || die "bootstrap failed"
#	PATH="${LIBTOOL_D}/bin:${PATH}" eautoreconf
	PATH="${LIBTOOL_D}/bin:${PATH}" elibtoolize
}

src_configure() {
	local myconf
	for USEFLAG in ${IUSE}; do
		myconf+=" $(use_with ${USEFLAG/+/})"
	done

	# This flags either result in compilation errors
	# or byzantine runtime behaviour.
	filter-flags -fwhole-program -fwhopr

	PATH="${LIBTOOL_D}/bin:${PATH}" econf \
		--enable-libtool-lock \
		${myconf}
}

src_compile() {
	if use cpp; then
		# -jx fails for x > 1 with use cpp
		PATH="${LIBTOOL_D}/bin:${PATH}" emake -j1 || die "emake install failed"
	else
		PATH="${LIBTOOL_D}/bin:${PATH}" emake || die "emake install failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
