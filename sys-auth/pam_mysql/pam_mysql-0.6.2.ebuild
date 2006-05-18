# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils libtool

DESCRIPTION="pam_mysql is a module for pam to authenticate users with mysql"
HOMEPAGE="http://pam-mysql.sourceforge.net/"

SRC_URI="mirror://sourceforge/pam-mysql/${P}.tar.gz"
DEPEND=">=sys-libs/pam-0.72 
	>=dev-db/mysql-3.23.38
	ssl? ( dev-libs/openssl )
	sasl? ( =dev-libs/cyrus-sasl-2* )
	"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="ssl sasl"

src_unpack() {
	unpack ${A}

	cd ${S}
	elibtoolize
}

src_compile() {
	local myconf="--with-mysql=/usr"
	if use ssl; then
		myconf="${myconf} --with-openssl"
	fi
	if use sasl; then
		myconf="${myconf} --with-sasl2"
	fi
	econf ${myconf}

	if use ssl; then
		sed 's/DEFS = /DEFS = -DHAVE_OPENSSL /g' Makefile > Makefile.new \
		&& mv Makefile.new Makefile
	elif use sasl; then
		sed 's/DEFS = /DEFS = -DHAVE_SASL_MD5_H -DHAVE_CYRUS_SASL_V2 /g' Makefile > Makefile.new \
		&& mv Makefile.new Makefile
	fi
	emake
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc CREDITS ChangeLog NEWS README
}
