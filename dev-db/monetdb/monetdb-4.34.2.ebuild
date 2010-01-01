# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

M4_PV=${PV}
XQ_PV=0.34.2

DESCRIPTION="MonetDB/SQL is a main-memory column-store database"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB4-server-${M4_PV}.tar.lzma
	http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB-XQuery-${XQ_PV}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1 PathfinderPL-1.1"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="java boehmgc"

S=${WORKDIR}

RDEPEND="dev-libs/libpcre
	dev-libs/openssl
	sys-libs/readline
	dev-libs/libxml2
	java? ( dev-java/ant >=virtual/jdk-1.5 )
	boehmgc? ( dev-libs/boehm-gc )
	>=dev-db/monetdb-5"
DEPEND="app-arch/lzma-utils
	${RDEPEND}"

pkg_preinst() {
	# should already exist, but for completeness here
	enewgroup monetdb
	enewuser monetdb -1 -1 -1 monetdb
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/xquery-0.20.0-bool-undeclared.patch
}

src_compile() {
	local myconf=
	# Upstream likes to stick things like -O6 and what more in CFLAGS
	myconf+=" --disable-strict --disable-optimize --disable-assert"
	myconf+=" $(use_with java)"
	myconf+=" --without-php"
	myconf+=" $(use_with boehmgc gc)"

	cd "${S}"/MonetDB4-${M4_PV} || die
	econf --with-monetdb="${EPREFIX}" ${myconf} || die
	emake || die "MonetDB4"

	mkdir "${T}"/bin
	cp conf/monetdb4-config "${T}"/bin/monetdb4-config
	chmod 755 "${T}"/bin/monetdb4-config

	append-flags -I"${S}"/MonetDB4-${M4_PV}
	append-flags -I"${S}"/MonetDB4-${M4_PV}/src/monet
	append-ldflags -L"${S}"/MonetDB4-${M4_PV}/src/monet/.libs
	append-flags -I"${S}"/MonetDB4-${M4_PV}/src
	append-ldflags -L"${S}"/MonetDB4-${M4_PV}/src/mapi/.libs
	append-flags -I"${S}"/MonetDB4-${M4_PV}/src/modules/plain
	append-ldflags -L"${S}"/MonetDB4-${M4_PV}/src/modules/plain/.libs
	append-flags -I"${S}"/MonetDB4-${M4_PV}/src/modules/contrib
	append-ldflags -L"${S}"/MonetDB4-${M4_PV}/src/modules/contrib/.libs
	cd "${S}"/MonetDB-XQuery-${XQ_PV} || die
	econf --with-monetdb="${EPREFIX}" --with-monetdb4="${T}" ${myconf} || die
	emake || die "xquery"
}

src_install() {
	cd "${S}"/MonetDB4-${M4_PV} || die
	emake DESTDIR="${D}" install || die "MonetDB4"

	cd "${S}"/MonetDB-XQuery-${XQ_PV} || die
	emake DESTDIR="${D}" install || die "xquery"

	# remove windows cruft
	find "${D}" -name "*.bat" | xargs rm -f || die "removing windows stuff"
}
