# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

COMMON_PV=1.34.2
CLIENTS_PV=1.34.2
M5_PV=${PV}
SQL_PV=2.34.2

DESCRIPTION="MonetDB/SQL is a main-memory column-store database"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB-${COMMON_PV}.tar.lzma
	http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB-client-${CLIENTS_PV}.tar.lzma
	http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB5-server-${M5_PV}.tar.lzma
	http://monetdb.cwi.nl/downloads/sources/Nov2009-SP1/MonetDB-SQL-${SQL_PV}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="python perl php iconv bzip2 zlib rdf xml java"

S=${WORKDIR}

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	python? ( dev-lang/python )
	perl? ( dev-lang/perl )
	php? ( dev-lang/php )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	rdf? ( >=media-libs/raptor-1.4.16 )
	xml? ( dev-libs/libxml2 )
	java? ( dev-java/ant >=virtual/jdk-1.4 <=virtual/jdk-1.6 )"
DEPEND="app-arch/lzma-utils
	${RDEPEND}"

pkg_preinst() {
	enewgroup monetdb
	enewuser monetdb -1 -1 -1 monetdb
}

src_compile() {
	local myconf=
	# Upstream likes to stick things like -O6 and what more in CFLAGS
	myconf+=" --disable-strict --disable-optimize --disable-assert"
	# Deal with auto-dependencies
	use python 	&& myconf+=" $(use_with python)"
	use perl	&& myconf+=" $(use_with perl)"
	use php		&& myconf+=" $(use_with php)"
	use java 	&& myconf+=" $(use_with java)"
	use iconv	&& myconf+=" $(use_with iconv)"
#	use curl	&& myconf+=" $(use_with curl)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use xml		&& myconf+=" $(use_with xml libxml2)"

	cd "${S}"/MonetDB-${COMMON_PV} || die
	econf ${myconf} || die
	emake || die "common"

	mkdir "${T}"/bin
	cp conf/monetdb-config "${T}"/bin/monetdb-config
	chmod 755 "${T}"/bin/monetdb-config

	append-flags -I"${S}"/MonetDB-${COMMON_PV}/src/common
	append-ldflags -L"${S}"/MonetDB-${COMMON_PV}/src/common/.libs
	cd "${S}"/MonetDB-client-${CLIENTS_PV} || die
	econf --with-monetdb="${T}" ${myconf} || die
	emake || die "clients"

	append-flags -I"${S}"/MonetDB-${COMMON_PV}
	append-flags -I"${S}"/MonetDB-${COMMON_PV}/src/gdk
	append-ldflags -L"${S}"/MonetDB-${COMMON_PV}/src/gdk/.libs
	append-flags -I"${S}"/MonetDB-client-${CLIENTS_PV}/src
	append-ldflags -L"${S}"/MonetDB-client-${CLIENTS_PV}/src/mapilib/.libs
	cd "${S}"/MonetDB5-server-${M5_PV} || die
	econf --with-monetdb="${T}" ${myconf} || die
	emake || die "MonetDB5"

	cp conf/monetdb5-config "${T}"/bin/monetdb5-config
	chmod 755 "${T}"/bin/monetdb5-config

	append-flags -I"${S}"/MonetDB5-server-${M5_PV}
	append-flags -I"${S}"/MonetDB5-server-${M5_PV}/src/{mal,optimizer,scheduler}
	append-ldflags -L"${S}"/MonetDB5-server-${M5_PV}/src/{mal,optimizer,scheduler}/.libs
	append-flags -I"${S}"/MonetDB5-server-${M5_PV}/src/modules/{atoms,kernel,mal}
	append-ldflags -L"${S}"/MonetDB5-server-${M5_PV}/src/modules/{atoms,kernel,mal}/.libs
	if use rdf; then
		myconf+=" $(use_with rdf raptor)"
		append-ldflags -L"${S}"/MonetDB5-server-${M5_PV}/src/modules/mal/rdf/.libs
	fi
	cd "${S}"/MonetDB-SQL-${SQL_PV} || die
	econf --with-monetdb="${T}" --with-monetdb5="${T}" ${myconf} || die
	emake || die "sql"
}

src_install() {
	cd "${S}"/MonetDB-${COMMON_PV} || die
	emake DESTDIR="${D}" install || die "common"

	cd "${S}"/MonetDB-client-${CLIENTS_PV} || die
	emake DESTDIR="${D}" install || die "clients"

	cd "${S}"/MonetDB5-server-${M5_PV} || die
	# parallel is broken here
	emake -j1 DESTDIR="${D}" install || die "MonetDB5"

	cd "${S}"/MonetDB-SQL-${SQL_PV} || die
	emake DESTDIR="${D}" install || die "sql"

	# remove testing framework and compiled tests
	rm -f \
		"${D}/usr/bin/Mapprove.py" \
		"${D}/usr/bin/Mdiff" \
		"${D}/usr/bin/Mfilter.py" \
		"${D}/usr/bin/MkillUsers" \
		"${D}/usr/bin/Mlog" \
		"${D}/usr/bin/Mprofile.py" \
		"${D}/usr/bin/Mtest.py" \
		"${D}/usr/bin/Mtimeout" \
		"${D}/usr/bin/prof.py" \
		"${D}/usr/share/MonetDB/Mprofile-commands.lst" \
		"${D}/usr/MonetDB/subprocess26.py" \
		"${D}/usr/MonetDB/trace.py" \
		"${D}/usr/MonetDB/__init__.py" \
		"${D}/usr/MonetDB/monet_options.py" \
		|| die "removing testing tools"
	rm -Rf \
		"${D}/usr/lib/MonetDB/Tests" \
		"${D}/usr/lib/sql/Tests" \
		"${D}/usr/share/MonetDB/Tests" \
		"${D}/usr/share/sql/Tests" \
		|| die "removing tests"
	# remove windows cruft
	find "${D}" -name "*.bat" | xargs rm -f || die "removing windows stuff"

	newinitd "${FILESDIR}/${PN}.init-5.2.0" monetdb || die "init.d script"
	newconfd "${FILESDIR}/${PN}.conf-5.2.0" monetdb || die "conf.d file"

	# rewrites to match FHS-2.3
	sed -e 's#/var/lib/log#/var/log#g' -e 's#/var/lib/run#/var/run#g' -i "${D}/etc/monetdb5.conf" \
	|| die "monetdb5.conf"
	mv "${D}/var/lib/log" "${D}/var/log"
	mv "${D}/var/lib/run" "${D}/var/run"

	# merovingian needs this
	keepdir /var/lib/MonetDB5/dbfarm
}
