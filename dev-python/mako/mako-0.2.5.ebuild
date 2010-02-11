# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit distutils eutils

DESCRIPTION="A python templating language."
HOMEPAGE="http://www.makotemplates.org/"
MY_P="Mako-${PV}"
SRC_URI="http://www.makotemplates.org/downloads/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm sparc ppc hppa"
IUSE="doc test gstringc"

RDEPEND="gstringc? ( dev-python/gstringc )"
DEPEND="${RDEPEND}
	dev-python/setuptools"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	if use gstringc; then
		epatch "${FILESDIR}"/mako-0.2.5-gstringc.patch
	fi
}

src_install() {
	distutils_src_install
	use doc && dohtml doc/*html doc/*css
}

src_test() {
	PYTHONPATH="./lib" "${python}" test/alltests.py || die "tests failed"
}
