# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/trac/trac-0.10.2.ebuild,v 1.1 2006/11/13 22:58:36 dju Exp $

inherit distutils webapp

DESCRIPTION="Trac is a minimalistic web-based project management, wiki and bug/issue tracking system."
HOMEPAGE="http://trac.edgewall.com/"
SRC_URI="http://ftp.edgewall.com/pub/trac/${P}.tar.gz"

LICENSE="trac"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cgi fastcgi mysql postgres sqlite enscript silvercity"

# doing so because utils (such as trac-admin), manpages... overlap
SLOT="0"
WEBAPP_MANUAL_SLOT="yes"

# we need to depend on virtual/httpd-cgi to pull apache/lighttpd/whatever in when USE cgi
# we need to depend on virtual/httpd-fcgi to pull mod_fastcgi/lighttpd/whatever in when USE fastcgi
# we need to depend on virtual/httpd-python to pull mod_python/whatever in when USE python (python
# is rather confusing here, as dev-lang/python is a required dependency, but httpd-python isn't)
DEPEND="${DEPEND}
	>=dev-lang/python-2.3
	app-text/pytextile
	>=dev-python/docutils-0.3.9
	>=dev-libs/clearsilver-0.9.3
	>=dev-util/subversion-1.3.2
	mysql? (
		>=virtual/mysql-4.1.0
		>=dev-python/mysql-python-1.2.1
	)
	sqlite? (
		>=dev-db/sqlite-3.3.4
		>=dev-python/pysqlite-2.3
	)
	postgres? ( >=dev-python/psycopg-2 )
	enscript? ( app-text/enscript )
	silvercity? ( app-text/silvercity )"

# The following function should be added to eutils.eclass (see bug #143572):

# Generate an standard error message for missing USE flags
# in existing packages, and die.
#
# Usage: built_with_use_error <category/package> <functionality> [<USE flag>]
#    ex: built_with_use_error dev-util/subversion python
#    or: built_with_use_error net-www/apache LDAP ldap
#
# Typical usage:
#	if ! built_with_use dev-util/subversion python ; then
#        built_with_use_error dev-util/subversion python
#   fi
#
# Note: when <USE flag> is not specified, <functionality> is used for the USE flag name.
built_with_use_error_msg() {
	local package=$1
	local func=$2
	local use_flag=$3

	[[ -z ${use_flag} ]] && use_flag=${func}

	eerror "Your ${package} package has been built without"
	eerror "${func} support, please enable the '${use_flag}' USE flag and"
	eerror "re-emerge ${package}."
	einfo "You can enable this USE flag either globally in /etc/make.conf,"
	einfo "or just for specific packages in /etc/portage/package.use."
	die "${package} missing ${func} support"
}

pkg_setup () {
	if ! use mysql && ! use postgres && ! use sqlite ; then
		eerror "You must select at least one database backend, by enabling"
		eerror "at least one of the 'mysql', 'postgres' or 'sqlite' USE flags."
		die "no database backend selected"
	fi

	if ! built_with_use dev-util/subversion python ; then
		built_with_use_error dev-util/subversion python
	fi

	if ! built_with_use dev-libs/clearsilver python ; then
		built_with_use_error dev-libs/clearsilver python
	fi

	ebegin "Creating tracd group and user"
	enewgroup tracd
	enewuser tracd -1 -1 -1 tracd
	eend ${?}

	webapp_pkg_setup
}

src_compile() {
	epatch ${FILESDIR}/trac-0.10.3-to-r2.patch
	epatch ${FILESDIR}/trac-0.10.0-ISO8601.patch
}

src_install () {
	# project environments might go in here
	keepdir /var/lib/trac

	webapp_src_preinst
	distutils_src_install

	dodoc AUTHORS INSTALL RELEASE THANKS UPGRADE
	rm ${D}/usr/share/doc/${P}/MANIFEST.in.gz
	rm ${D}/usr/share/doc/${P}/PKG-INFO.gz

	docinto contrib
	dodoc contrib/*

	# if needed, install cgi/fcgi scripts for webapp-config
	local my_dir=${D}/usr/share/trac
	if use cgi ; then
		mv ${my_dir}/cgi-bin/trac.cgi ${D}${MY_CGIBINDIR} || die
	fi
	if use fastcgi ; then
		mv ${my_dir}/cgi-bin/trac.fcgi ${D}${MY_CGIBINDIR} || die
	fi
	rm -rf ${my_dir}/cgi-bin || die

	for lang in en; do
		webapp_postinst_txt ${lang} ${FILESDIR}/postinst-${lang}.txt
	done

	# copy graphics, css & js
	cp -r htdocs/* ${D}/${MY_HTDOCSDIR}

	webapp_src_install

	newconfd "${FILESDIR}"/tracd.confd tracd
	newinitd "${FILESDIR}"/tracd.initd tracd
}
