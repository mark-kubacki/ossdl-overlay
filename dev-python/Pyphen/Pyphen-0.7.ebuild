# Copyright 2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="Pure Python module to hyphenate text"
HOMEPAGE="https://pypi.python.org/pypi/Pyphen"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86 arm"
IUSE=""

PYTHON_MODNAME="pyphen"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.7-dicts.patch"
}

DOCS="README"
