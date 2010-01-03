# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

MY_PN="MonetDB5-server"
MY_P=${MY_PN}-${PV}

DESCRIPTION="MonetDB's MAL-based server. This can be used with and is recommended for SQL."
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/${MY_P}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="debug curl iconv bzip2 zlib rdf xml coroutines"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	curl? ( net-misc/curl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	rdf? ( >=media-libs/raptor-1.4.16 )
	xml? ( dev-libs/libxml2 )
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
		hasq "-O6" ${CFLAGS} || myconf+=" --enable-optimize"
	fi
	# Deal with auto-dependencies
	use curl	&& myconf+=" $(use_with curl)"
	use iconv	&& myconf+=" $(use_with iconv)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use xml		&& myconf+=" $(use_with xml libxml2)"
	use rdf		&& myconf+=" $(use_with rdf raptor)"
	use coroutines	&& myconf+=" $(use_with coroutines pcl)"

	econf ${myconf} || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	# set proper ACL
	chown -R monetdb:monetdb "${D}"/var/lib/MonetDB5
	chmod -R 0750 "${D}"/var/lib/MonetDB5
	keepdir /var/lib/MonetDB5/dbfarm

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb5-config
	dosbin conf/monetdb5-config

	# rewrites to match FHS-2.3
	dosed "s:/var/lib/log:/var/log:g" /etc/monetdb5.conf
	dosed "s:/var/lib/run:/var/run:g" /etc/monetdb5.conf
	fowners monetdb:monetdb /etc/monetdb5.conf
	fperms 0750 /etc/monetdb5.conf

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"
}
