# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils webapp

MY_PV=0.10
DESCRIPTION="Trac is a minimalistic web-based project management, wiki and bug/issue tracking system."
HOMEPAGE="http://trac.edgewall.org/"
SRC_URI="http://ftp.edgewall.com/pub/trac/${PN}-${MY_PV}.tar.gz"
S=${PN}-${MY_PV}

LICENSE="trac"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="apache cgi fastcgi postgres sqlite mysql enscript silvercity"

# doing so because utils (such as trac-admin), manpages... overlap
SLOT="0"
WEBAPP_MANUAL_SLOT="yes"

RDEPEND="${DEPEND}
	>=dev-lang/python-2.3
	app-text/pytextile
	>=dev-python/docutils-0.3.9
	>=dev-libs/clearsilver-0.9.3
	>=dev-util/subversion-1.2
	apache? ( >=dev-python/mod_python-3.1.3 )
	sqlite? ( >=dev-python/pysqlite-2 )
	postgres? ( dev-python/psycopg )
	mysql? ( >=dev-db/mysql-4.1.0 >=dev-python/mysql-python-1.2.1 )
	enscript? ( app-text/enscript )
	silvercity? ( app-text/silvercity )"

pkg_setup () {
	if ! use postgres && ! use sqlite && ! use mysql ; then
		eerror "You must select at least one database backend,"
		eerror "using sqlite, postgres or mysql USE flags."
		die "no database backend selected"
	fi

	if ! built_with_use dev-util/subversion python ; then
		eerror "Your subversion has been built without python bindings,"
		eerror "please enable the 'python' useflag and recompile"
		eerror "dev-util/subversion."
		die "pkg_setup failed"
	fi

	if ! built_with_use dev-libs/clearsilver python ; then
		eerror "Your clearsilver has been built without python bindings,"
		eerror "please enable the 'python' useflag and recompile"
		eerror "dev-libs/clearsilver."
		die "pkg_setup failed"
	fi

	ebegin "Creating tracd group and user"
	enewgroup tracd
	enewuser tracd -1 -1 -1 tracd
	eend ${?}

	webapp_pkg_setup
}

src_compile() {
	cd ${WORKDIR}/${S}
	epatch ${FILESDIR}/trac-0.10.0-ISO8601.patch
}

src_install () {
	cd ${WORKDIR}/${S}
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
		webapp_postinst_txt ${lang} ${FILESDIR}/0.9.4-postinst-${lang}.txt
	done

	# copy graphics, css & js
	cp -r htdocs/* ${D}/${MY_HTDOCSDIR}

	webapp_src_install

	cp ${FILESDIR}/tracd.confd ${T}/tracd && doconfd ${T}/tracd
	cp ${FILESDIR}/tracd.initd ${T}/tracd && doinitd ${T}/tracd
}
