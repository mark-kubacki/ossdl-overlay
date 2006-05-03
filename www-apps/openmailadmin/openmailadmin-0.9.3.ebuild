# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp

DESCRIPTION="Administration interface for mailservers based on Cyrus and any MTA."
SRC_URI="http://static.openmailadmin.org/downloads/${PN}-${PV}.tbz2"
HOMEPAGE="http://www.openmailadmin.org/"
RESTRICT="nomirror"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="mysql mysqli pam"

DEPEND="
        pam? ( || (
                mysql?          ( >=sys-auth/pam_mysql-0.6.2 )
                mysqli?         ( >=sys-auth/pam_mysql-0.6.2 )
        ))
        "
RDEPEND="${DEPEND}
	virtual/httpd-php
	>=dev-lang/php-4.3.0
	dev-php/adodb
	virtual/mta
	<net-mail/cyrus-imapd-2.3.0
	|| (
		mysqli?		( >=dev-db/mysql-4.1.14 )
		mysql?		( >=dev-db/mysql-4.1.0 )
	)
	pam?		( sys-auth/pam_pwdfile )
	!www-apps/web-cyradm
	"

src_install() {
	webapp_src_preinst

	cp -R [[:lower:]]* ${D}/${MY_HTDOCSDIR}
	rm -R ${D}/${MY_HTDOCSDIR}/samples
	dodoc INSTALL
	dosbin samples/oma_mail.daimon.php
	webapp_serverowned ${MY_HTDOCSDIR}/inc
	
	webapp_postinst_txt de ${FILESDIR}/postinstall-de.txt
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install	
}

pkg_config() {
	einfo "Type in your MySQL root password to create an empty openmailadmin database:"
	mysqladmin -u root -p create openmailadmin
}

pkg_postinst() {
	einfo "To setup a MySQL database, run:"
	einfo "\"emerge --config =${PF}\""
	einfo "If you are using PostgreSQL, consult your documentation"
	webapp_pkg_postinst
}
