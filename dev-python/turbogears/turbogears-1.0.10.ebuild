# Copyright 2008-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

KEYWORDS="amd64 x86 arm"

MY_PN=TurboGears
MY_P=${MY_PN}-${PV}
PYTHON_MODNAME=${MY_PN}

DESCRIPTION="The rapid web development meta-framework you've been looking for."
HOMEPAGE="http://www.turbogears.org/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/turbojson-1.1.4
	<dev-python/turbojson-1.2
	>=dev-python/turbocheetah-1.0
	>=dev-python/turbokid-1.0.2
	=dev-python/cherrypy-2.3*
	dev-python/extremes
	>=dev-python/simplejson-1.3
	>=dev-python/elementtree-1.2.6-r2
	>=dev-python/pastescript-1.6.2
	>=dev-python/formencode-0.7.1
	>=dev-python/ruledispatch-0.5_pre2306-r2
		dev-python/pyprotocols
	>=dev-python/decoratortools-1.4
	>=dev-python/configobj-4.3.2
	|| ( =dev-lang/python-2.4*
	     >=dev-python/cheetah-2.0_rc7-r1 )
	|| ( =dev-lang/python-2.5* =dev-lang/python-2.6* =dev-lang/python-2.7*
		( =dev-lang/python-2.4* >=dev-python/celementtree-1.0.5 ) )
	>=dev-python/sqlobject-0.7
	test? ( >=dev-python/nose-0.9.1 >=dev-python/sqlalchemy-0.3.3
		|| ( =dev-lang/python-2.5* =dev-lang/python-2.6* =dev-lang/python-2.7*
			( =dev-lang/python-2.4* dev-python/pysqlite ) ) )
	>=dev-python/mako-0.1.1
	>=dev-python/markdown-2.0.1
	>=dev-python/genshi-0.3.6"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.6_rc5"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGELOG.txt CONTRIBUTORS.txt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/tg-1.0-mako_i18n_collect.patch"
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
