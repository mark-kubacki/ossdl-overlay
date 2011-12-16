# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 3.*"
DISTUTILS_SRC_TEST="setup.py"
PYTHON_DEPEND="2:2.4:2.7"

inherit distutils

DESCRIPTION="Eventlet is a networking library featuring non-blocking io and using coroutines."
HOMEPAGE="http://eventlet.net/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm sparc ppc hppa"
IUSE="doc"

RDEPEND=">=dev-python/greenlet-0.2"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_install() {
	distutils_src_install
	use doc && dohtml doc/*html doc/*css
}
