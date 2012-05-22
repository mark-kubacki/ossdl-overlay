# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Implementation of the Hyper LogLog cardinality counter algorithm"
HOMEPAGE="http://pypi.python.org/pypi/hyperloglog
	http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.76.4286"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL"
KEYWORDS="amd64 x86 arm"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools
	"
