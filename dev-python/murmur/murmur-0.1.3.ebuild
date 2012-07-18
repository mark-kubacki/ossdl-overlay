# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* 2.7-pypy-* *-jython"

inherit distutils

MY_PN=Murmur
MY_P=${MY_PN}-${PV}

DESCRIPTION="Provides fast murmur hashes for strings, files, and ziped files."
HOMEPAGE="http://pypi.python.org/pypi/Murmur"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND="
	|| ( <sys-libs/zlib-1.2.5.1 >=sys-libs/zlib-1.2.5.2 )
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
