# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.*"

inherit distutils

DESCRIPTION="A python interface to thepiratebay dot org"
HOMEPAGE="http://hg.sobber.org/piratebay"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
KEYWORDS="amd64 x86 arm ppc hpa sparc"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/lxml"

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/piratebay
}
