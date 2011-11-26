# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_PN=Murmur
MY_P=${MY_PN}-${PV}

DESCRIPTION="Provides fast murmur hashes for strings, files, and ziped files."
HOMEPAGE="http://pypi.python.org/pypi/Murmur"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND=">=dev-lang/python-2.5
	|| ( <sys-libs/zlib-1.2.5.1 >=sys-libs/zlib-1.2.5.2 )
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
