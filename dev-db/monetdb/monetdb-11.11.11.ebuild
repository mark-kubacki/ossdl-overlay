# Copyright 2009-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit flag-o-matic

MY_PN="MonetDB"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A column-store based (R)DBMS."
HOMEPAGE="http://www.monetdb.org/"
SRC_URI="http://dev.monetdb.org/downloads/sources/Jul2012-SP2/${MY_P}.tar.xz"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 ~arm"
IUSE="debug -rdf datacell fits +sql -console -odbc -static curl iconv -java bzip2 zlib perl -ruby sphinx geom hwcounter"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	rdf? ( =media-libs/raptor-1.4* )
	console? ( sys-libs/readline )
	odbc? ( dev-db/unixODBC )
	curl? ( net-misc/curl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	java? ( >=virtual/jdk-1.4 dev-java/ant )
	perl? ( >=dev-lang/perl-5.8.0 )
	ruby? ( dev-lang/ruby dev-ruby/rubygems )
	sphinx? ( app-misc/sphinx )
	geom? ( >=sci-libs/geos-2.2.0 )
	fits? ( sci-libs/cfitsio )
	!dev-db/monetdb-common"
DEPEND="app-arch/xz-utils
	mail-filter/procmail
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup monetdb 61 || die "problem adding 'monetdb' group"
	enewuser monetdb 61 -1 /dev/null monetdb || die "problem adding 'monetdb' user"
}

src_configure() {
	local myconf=
	if use debug; then
		myconf+=" --enable-strict --enable-assert --disable-optimize --enable-debug --enable-assert"
	else
		myconf+=" --disable-strict --disable-debug --disable-testing --disable-assert"
		if ! has "-O6" ${CFLAGS}; then
			myconf+=" --enable-optimize"
			filter-flags "-Os" "-O" "-O[012345]"
		fi
	fi

	if use console; then
		einfo "The console is a direct client hooked onto the kernel with full"
		einfo "administrative privileges, bypassing any security checks.  It is"
		einfo "handy only during development."
	fi

	if ! use java; then
		einfo "RIPEMD160 has been selected for the password-backend."
		einfo "It is not compatible to JDBC."
		myconf+=" --with-password-backend=RIPEMD160"
	fi

	# MonetDB doesn't recognize all of these options, yet.
	# They are enabled on a 'library exists' basis - which is ugly.
	# Nevertheless I include the options here so that users
	#  can send complaints to the MonetDB makers. ;-)
	econf $(use_enable sql monetdb5) \
		$(use_enable rdf) \
		$(use_enable datacell) \
		$(use_enable sql) \
		$(use_enable geom) \
		$(use_enable odbc) \
		$(use_enable console) \
		$(use_enable java jdbc) \
		$(use_enable static) \
		$(use_enable fits) \
		$(use_with curl) \
		$(use_with iconv) \
		$(use_with bzip2 bz2) \
		$(use_with zlib z) \
		$(use_with perl) \
		--without-python \
		$(use_with ruby) \
		$(use_with java ant) \
		$(use_with java) \
		$(use_with sphinx sphinxclient) \
		$(use_with geom geos) \
		$(use_with hwcounter) \
		--with-logdir=/var/log/monetdb --with-rundir=/var/run/monetdb \
		${myconf} || die "econf"
	einfo "Some options might've not been recognized. That's okay."
	einfo "Notify <fabian@monetdb.org> about them."
}

src_compile() {
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	newinitd "${FILESDIR}"/monetdb.init-11.5.9 monetdb || die "init.d script"
	newconfd "${FILESDIR}"/monetdb.conf-11.5.9 monetdb || die "conf.d file"

	# set proper ACL
	chown -R monetdb:monetdb "${D}"/var/lib/monetdb5
	chmod -R 0750 "${D}"/var/lib/monetdb5
	keepdir /var/lib/monetdb5/dbfarm

	# directory-moves to match FHS-2.3
	chown -R monetdb:root "${D}"/var/run/monetdb
	chmod -R 0755 "${D}"/var/run/monetdb
	keepdir /var/run/monetdb
	chown -R monetdb:monetdb "${D}"/var/log/monetdb
	chmod -R 0750 "${D}"/var/log/monetdb
	keepdir /var/log/monetdb

	# remove parts which we didn't ask for
	if ! use ruby; then
		test -d "${D}"/usr/lib/ruby && rm -r "${D}"/usr/lib/ruby
		test -d "${D}"/usr/lib64/ruby && rm -r "${D}"/usr/lib64/ruby
	fi
}

pkg_postinst() {
	einfo "The init script refers to a database-farm stored under"
	einfo "  /var/lib/monetdb5/dbfarm"
	einfo "A /etc/monetdb*.conf file no longer exists. Configuration"
	einfo "happens by .merovingian_properties files inside the dbfarm(s)"
	einfo "using the commands:"
	einfo "  # monetdbd set property=... [dbfarm]"
	einfo ""
	einfo "The init script starts the aforementioned db-farm as user 'monetdb'."
	einfo "Your first steps could be:"
	einfo "  # sudo -u monetdb monetdb create test"
	einfo "  # sudo -u monetdb monetdb release test"
	einfo "  # mclient -u monetdb -d test"
	einfo "  sql> ALTER USER SET PASSWORD 'other_password' USING OLD PASSWORD 'monetdb';"
	einfo "  sql> \q"
}
