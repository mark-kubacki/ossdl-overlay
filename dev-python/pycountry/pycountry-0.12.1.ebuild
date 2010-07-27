# Copyright 2008-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="ISO country, subdivision, language, currency and script definitions and their translations for Python"
HOMEPAGE="http://pypi.python.org/pypi/pycountry"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="LGPL"
KEYWORDS="amd64 ia64 ppc sparc x86 arm"
IUSE=""
SLOT="0"

RDEPEND="dev-python/lxml"
DEPEND="${RDEPEND}
	dev-python/setuptools"
