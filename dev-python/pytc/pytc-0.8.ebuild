# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="Tokyo Cabinet Python bindings"
HOMEPAGE="http://coderepos.org/share/browser/lang/python/pytc"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

RDEPEND=">=dev-db/tokyocabinet-1.3.19"
DEPEND="${RDEPEND}
	dev-python/setuptools"
