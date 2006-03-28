# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.2.6.ebuild,v 1.1 2006/03/27 22:56:34 wmark Exp $

inherit eutils

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.gz mirror://apache/apr/apr-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="berkdb gdbm ldap postgres sqlite sqlite3 mysql"
RESTRICT="test"

DEPEND="dev-libs/expat
	~dev-libs/apr-${PV}
	berkdb? ( =sys-libs/db-4* )
	gdbm? ( sys-libs/gdbm )
	ldap? ( =net-nds/openldap-2* )
	mysql? ( >=dev-db/mysql-4.1.0 )
	postgres? ( dev-db/postgresql )
	sqlite? ( =dev-db/sqlite-2* )
	sqlite3? ( =dev-db/sqlite-3* )"

src_unpack() {
	unpack ${A} || die
	if use mysql; then
		cd ${WORKDIR}/${P}/dbd
		wget http://apache.webthing.com/svn/apache/apr/apr_dbd_mysql.c
	fi
}


src_compile() {

	if use mysql; then
	    cd ${WORKDIR}/${P}
	    ./buildconf --with-apr=../apr-${PV}
	fi

	local myconf=""

	use ldap && myconf="${myconf} --with-ldap"
	use mysql && myconf="${myconf} --with-mysql=/usr"
	myconf="${myconf} $(use_with gdbm)"
	myconf="${myconf} $(use_with postgres pgsql)"
	myconf="${myconf} $(use_with sqlite sqlite2)"
	myconf="${myconf} $(use_with sqlite3)"

	if use berkdb; then
		if has_version '=sys-libs/db-4.3*'; then
			myconf="${myconf} --with-dbm=db43
			--with-berkeley-db=/usr/include/db4.3:/usr/$(get_libdir)"
		elif has_version '=sys-libs/db-4.2*'; then
			myconf="${myconf} --with-dbm=db42
			--with-berkeley-db=/usr/include/db4.2:/usr/$(get_libdir)"
		elif has_version '=sys-libs/db-4*'; then
			myconf="${myconf} --with-dbm=db4
			--with-berkeley-db=/usr/include/db4:/usr/$(get_libdir)"
		fi
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	econf \
		--datadir=/usr/share/apr-util-1 \
		--with-apr=/usr \
		--with-expat=/usr \
		$myconf || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGES NOTICE
}
