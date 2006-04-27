# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_mysql/pam_mysql-0.6.0.ebuild,v 1.1 2005/07/04 14:20:50 azarah Exp $

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
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
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
		epatch ${FILESDIR}/pam_mysql-0.6_md5_openssl.patch
	elif use sasl; then
                epatch ${FILESDIR}/pam_mysql-0.6_md5_sasl2.patch
	fi
	emake
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc CREDITS ChangeLog NEWS README
}
