# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5 3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="Cross-platform colored terminal text library"
HOMEPAGE="http://code.google.com/p/colorama
	http://pypi.python.org/pypi/colorama"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm sparc"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools
	"
