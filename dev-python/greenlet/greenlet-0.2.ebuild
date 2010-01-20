# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit distutils flag-o-matic

DESCRIPTION="Lightweight in-process concurrent programming."
HOMEPAGE="http://pypi.python.org/pypi/greenlet"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 ppc ~sparc ~arm"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_unpack() {
        unpack ${A}
        cd "${S}"

	if use arm; then
        	epatch "${FILESDIR}/greenlet-0.2-iphoneos.patch"
        	epatch "${FILESDIR}/greenlet-0.2-arm32.patch"
		ewarn "You must set -march=XXX in CFLAGS or greenlet will lead to 'Illegal instruction' errors."
		append-flags -pipe -combine -fomit-frame-pointer
	fi
}

src_install() {
	distutils_src_install
	use doc && dohtml doc/*html doc/*css
}
