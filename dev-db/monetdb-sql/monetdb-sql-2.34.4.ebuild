# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

MY_PN="MonetDB-SQL"
MY_P=${MY_PN}-${PV}

DESCRIPTION="SQL server built on top of (targeted on) MonetDB5"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP2/${MY_P}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 ~arm"
IUSE="debug curl iconv bzip2 zlib rdf xml coroutines"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	curl? ( net-misc/curl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	rdf? ( dev-db/monetdb5-server[rdf] )
	xml? ( dev-db/monetdb5-server[xml] )
	coroutines? ( dev-libs/pcl )
	>=dev-db/monetdb-common-1.34.0
	>=dev-db/monetdb-client-1.34.0
	>=dev-db/monetdb5-server-5.16.0
	!!dev-db/monetdb"
DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup monetdb 61 || die "problem adding 'monetdb' group"
	enewuser monetdb 61 -1 /dev/null monetdb || die "problem adding 'monetdb' user"
}

src_compile() {
	local myconf=
	if use debug; then
		myconf+=" --enable-strict --disable-optimize --enable-debug --enable-assert"
	else
		myconf+=" --disable-strict --disable-debug --disable-assert"
		if ! hasq "-O6" ${CFLAGS}; then
			myconf+=" --enable-optimize"
			filter-flags "-Os" "-O" "-O[012345]"
		fi
	fi
	# Deal with auto-dependencies
	use curl	&& myconf+=" $(use_with curl)"
	use iconv	&& myconf+=" $(use_with iconv)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use coroutines	&& myconf+=" $(use_with coroutines pcl)"

	econf ${myconf} || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	newinitd "${FILESDIR}"/monetdb.init-5.2.0 monetdb || die "init.d script"
	newconfd "${FILESDIR}"/monetdb.conf-5.2.0 monetdb || die "conf.d file"
	einfo
	einfo "Remember to set a vault password. See /etc/monetdb5.conf."
	einfo "You can start MonetDB/SQL servers by /etc/init.d/monetdb."
	einfo

	ewarn
	ewarn "merovingian (the MonetDB manager) behaves quirky,"
	ewarn "therefore the init script may yield an error despite"
	ewarn "the process merovingian having been launched correctly."
	ewarn

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb-sql-config
	dosbin conf/monetdb-sql-config
	rm "${D}"/usr/bin/monetdb
	dosbin src/backends/monet5/merovingian/monetdb
	rm "${D}"/usr/bin/merovingian
	dosbin src/backends/monet5/merovingian/merovingian

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"
}
