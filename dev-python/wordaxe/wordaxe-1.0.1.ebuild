# Copyright 2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="Provides hyphenation for python programs and ReportLab paragraphs"
HOMEPAGE="http://deco-cow.sourceforge.net"
SRC_URI="mirror://sourceforge/deco-cow/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86 arm"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"
