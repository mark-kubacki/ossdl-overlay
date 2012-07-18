# Copyright 1999-2011 Gentoo Foundation
# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.7-pypy-* *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="http://pypi.python.org/pypi/greenlet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-python/setuptools
	app-arch/unzip"
RDEPEND=""

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="AUTHORS NEWS README"

src_prepare() {
	distutils_src_prepare
	#epatch "${FILESDIR}/${PN}-0.3.1-python-3.2.patch"

	if use arm; then
		epatch "${FILESDIR}/greenlet-0.2-iphoneos.patch"
		epatch "${FILESDIR}/greenlet-0.2-arm32.patch"
		ewarn "You must set -march=XXX in CFLAGS or greenlet will lead to 'Illegal instruction' errors."
		append-flags -pipe -combine -fomit-frame-pointer
	fi
}
