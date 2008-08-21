# Copyright 2008 OSSDL.de
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="ISO country, subdivision, language, currency and script definitions and their translations for Python"
HOMEPAGE="http://pypi.python.org/pypi/pycountry"
SRC_URI="http://cheeseshop.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="LGPL"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""
SLOT="0"

RDEPEND="dev-python/lxml"
DEPEND="${RDEPEND}
	dev-python/setuptools"
