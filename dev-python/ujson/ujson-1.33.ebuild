# Copyright 2011-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="Very fast JSON encoder/decoder for Python"
HOMEPAGE="https://github.com/esnme/ultrajson
	http://www.esn.me/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix amd64-fbsd ~sparc-fbsd x86-fbsd x64-freebsd x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix amd64-linux arm-linux ~ia64-linux x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools
	app-arch/unzip
	"
