# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="*:2.6"

inherit distutils

DESCRIPTION="A python interface to thepiratebay dot org"
HOMEPAGE="http://hg.sobber.org/piratebay"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
KEYWORDS="amd64 x86 arm ppc hpa sparc"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools
	${RDEPEND}"

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/piratebay
}
