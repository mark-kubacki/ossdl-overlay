# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2:2.6:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="A Python wrapper for Tokyo Cabinet database using ctypes"
HOMEPAGE="http://code.google.com/p/py-tcdb/"
SRC_URI="http://${PN}.googlecode.com/files/${PN}-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND="dev-db/tokyocabinet"
DEPEND="dev-python/setuptools
	${RDEPEND}"

PYTHON_MODNAME="tcdb"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PYTHON_MODNAME}"
}
