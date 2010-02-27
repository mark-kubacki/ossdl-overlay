# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic

MY_PN="MonetDB4-server"
MY_P=${MY_PN}-${PV}

DESCRIPTION="MonetDB's MIL-based server. This is required if you want to use XML/XQuery (pathfinder)."
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/${MY_P}.tar.lzma"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="debug bzip2 zlib netcdf coroutines"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	netcdf? ( sci-libs/netcdf )
	coroutines? ( dev-libs/pcl )
	>=dev-db/monetdb-common-1.34.0
	>=dev-db/monetdb-client-1.34.0
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
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use coroutines	&& myconf+=" $(use_with coroutines pcl)"
	use netcdf	&& myconf+=" $(use_with netcdf)"

	econf ${myconf} || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	# set proper ACL
	chown -R monetdb:monetdb "${D}"/var/lib/MonetDB4
	chmod -R 0750 "${D}"/var/lib/MonetDB4
	keepdir /var/lib/MonetDB4/dbfarm

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb4-config
	dosbin conf/monetdb4-config

	# rewrites to match FHS-2.3
	dosed "s:/var/lib/log:/var/log:g" /etc/MonetDB.conf
	dosed "s:/var/lib/run:/var/run:g" /etc/MonetDB.conf
	fowners monetdb:monetdb /etc/MonetDB.conf
	fperms 0644 /etc/MonetDB.conf

	# directory moves to match FHS-2.3
#	mv "${D}"/var/lib/log "${D}"/var/log
#	mv "${D}"/var/lib/run "${D}"/var/run
#	chown -R monetdb:root "${D}"/var/run/MonetDB
#	chmod -R 0755 "${D}"/var/run/MonetDB
#	chown -R monetdb:monetdb "${D}"/var/log/MonetDB
#	chmod -R 0750 "${D}"/var/log/MonetDB

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"
}
