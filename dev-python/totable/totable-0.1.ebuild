# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="Cython wrapper for tokyo cabinet table"
HOMEPAGE="http://pypi.python.org/pypi/totable"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND="dev-db/tokyocabinet"
DEPEND="dev-python/setuptools
	${RDEPEND}"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}
