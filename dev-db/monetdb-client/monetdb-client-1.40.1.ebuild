# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils flag-o-matic

MY_PN="MonetDB-client"
MY_P=${MY_PN}-${PV}

DESCRIPTION="libraries and programs to communicate with the server(s) that are part of the MonetDB/SQL suite"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://dev.monetdb.org/downloads/sources/Oct2010/${MY_P}.tar.lzma"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="debug perl php ruby curl iconv bzip2 zlib odbc"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	perl? ( dev-lang/perl )
	php? ( dev-lang/php )
	ruby? ( dev-lang/ruby )
	curl? ( net-misc/curl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	odbc? ( dev-db/unixODBC )
	>=dev-db/monetdb-common-1.40.0
	!!dev-db/monetdb"
DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=
	if use debug; then
		myconf+=" --enable-strict --disable-optimize --enable-debug --enable-assert"
	else
		myconf+=" --disable-strict --disable-debug --disable-assert"
		if ! has "-O6" ${CFLAGS}; then
			myconf+=" --enable-optimize"
			filter-flags "-Os" "-O" "-O[012345]"
		fi
	fi
	# Deal with auto-dependencies
	use perl	&& myconf+=" $(use_with perl)"
	use php		&& myconf+=" $(use_with php)"
	use ruby	&& myconf+=" $(use_with ruby)"
	use curl	&& myconf+=" $(use_with curl)"
	use iconv	&& myconf+=" $(use_with iconv)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use odbc	&& myconf+=" $(use_with odbc unixodbc)"

	econf ${myconf} || die "econf"
}

src_compile() {
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb-clients-config
	dosbin conf/monetdb-clients-config

	# remove testing framework and compiled tests
	rm -rf "${D}"/usr/$(get_libdir)/MonetDB/Tests || true

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"

	# remove unwanted parts
	use php		|| rm -rf "${D}"/usr/share/php || true
	use perl	|| rm -rf "${D}"/usr/share/MonetDB/perl "${D}"/usr/$(get_libdir)/perl* || true
	use odbc	|| \
	rm -rf "${D}"/usr/$(get_libdir)/libMonetODBC* "${D}"/usr/include/MonetDB/odbc/ || true

	einfo "Monetdb-client doesn't ship with a Python client library anymore."
	einfo "If you need one, install dev-python/monetdb"
}
