# Copyright 2008 OSSDL.de
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils subversion

KEYWORDS="amd64 x86"

MY_PN=TurboGears
MY_P=${MY_PN}-${PV}

DESCRIPTION="The rapid web development meta-framework you've been looking for."
HOMEPAGE="http://www.turbogears.org/"
ESVN_REPO_URI="http://svn.turbogears.org/tags/${PV}"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/turbojson-1.0
	>=dev-python/turbocheetah-1.0
	>=dev-python/turbokid-1.0.2
	=dev-python/cherrypy-2.3*
	>=dev-python/simplejson-1.3
	>=dev-python/elementtree-1.2.6-r2
	>=dev-python/pastescript-1.6.2
	>=dev-python/formencode-0.7.1
	>=dev-python/ruledispatch-0.5_pre2306
	>=dev-python/decoratortools-1.4
	>=dev-python/configobj-4.3.2
	|| ( =dev-lang/python-2.4*
		( =dev-lang/python-2.5* >=dev-python/cheetah-2.0_rc7-r1 ) )
	|| ( =dev-lang/python-2.5*
		( =dev-lang/python-2.4* >=dev-python/celementtree-1.0.5 ) )
	>=dev-python/sqlobject-0.7
	test? ( >=dev-python/nose-0.9.1 >=dev-python/sqlalchemy-0.3.3
		|| ( =dev-lang/python-2.5*
			( =dev-lang/python-2.4* dev-python/pysqlite ) ) )
	>=dev-python/genshi-0.3.6"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.6_rc5"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGELOG.txt CONTRIBUTORS.txt"

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	epatch "${FILESDIR}/tg-1.0-url_encoding.patch"
	epatch "${FILESDIR}/tg-1.0-mako_i18n_collect.patch"
	epatch "${FILESDIR}/tg-1.0.4.4-r4741_upgrade.patch"
}

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}

pkg_postinst() {
	elog "While not directly depending on them, TurboGears works with/integrates"
	elog "the following packages:"
	elog " - dev-python/elixir"
	elog " - dev-python/sqlalchemy (already installed when built with tests enabled)"
	elog " - dev-python/tg-widgets-lightbox"
	elog " - dev-python/tg-widgets-scriptaculous"
}
