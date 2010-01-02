# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

MY_PN="MonetDB"
MY_P=${MY_PN}-${PV}

DESCRIPTION="fundamental libraries used in the other parts of the MonetDB/SQL suite"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/${MY_P}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="debug python perl iconv bzip2 zlib coroutines"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	python? ( >=dev-lang/python-2.4 )
	perl? ( dev-lang/perl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	coroutines? ( dev-libs/pcl )
	!!dev-db/monetdb"
DEPEND="app-arch/lzma-utils
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	local myconf=
	if use debug; then
		myconf+=" --enable-strict --disable-optimize --enable-debug --enable-assert"
	else
		myconf+=" --disable-strict --disable-debug --disable-assert"
		hasq "-O6" ${CFLAGS} || myconf+=" --enable-optimize"
	fi
	# Deal with auto-dependencies
	use python 	&& myconf+=" $(use_with python)"
	use perl	&& myconf+=" $(use_with perl)"
	use iconv	&& myconf+=" $(use_with iconv)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use coroutines	&& myconf+=" $(use_with coroutines pcl)"

	econf ${myconf} || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb-config
	dosbin conf/monetdb-config

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"
}
