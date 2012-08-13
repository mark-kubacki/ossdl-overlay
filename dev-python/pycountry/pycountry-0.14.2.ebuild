# Copyright 2008-2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="ISO country, subdivision, language, currency and script definitions and their translations"
HOMEPAGE="http://pypi.python.org/pypi/pycountry"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86 arm"
IUSE=""

RDEPEND="dev-python/lxml"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DOCS="HISTORY.txt TODO.txt"
