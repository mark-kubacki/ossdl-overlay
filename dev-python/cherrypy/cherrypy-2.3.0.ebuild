# Copyright 1999-2008 Gentoo Foundation
# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2 or OSI Reciprocal Public License (your choice)

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.*"

inherit eutils distutils

MY_P=CherryPy-${PV}

DESCRIPTION="CherryPy is a pythonic, object-oriented web development framework."
HOMEPAGE="http://www.cherrypy.org/"
SRC_URI="http://download.cherrypy.org/cherrypy/${PV}/${MY_P}.tar.gz"
RESTRICT="primaryuri"

IUSE="doc test"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc x86"
LICENSE="BSD"

DEPEND="dev-python/setuptools"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e '/raw_input/d' \
		cherrypy/test/test.py || die "sed failed"
	sed -i \
		-e 's/"cherrypy.tutorial",//' \
		-e "/('cherrypy\/tutorial',/, /),/d" \
		-e 's/distutils.core/setuptools/' \
		setup.py || die "sed failed"

}

src_install() {
	distutils_src_install
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r cherrypy/tutorial
	fi
}

src_test() {
	PYTHONPATH=. "${python}" cherrypy/test/test.py || die "test failed"
}
