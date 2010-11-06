# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit distutils

DESCRIPTION="Python client for Redis key-value store."
HOMEPAGE="http://github.com/andymccurdy/redis-py"
SRC_URI="http://binhost.ossdl.de/distfiles/${P}.tar.lzma"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm sparc ppc hppa"
IUSE="doc test"

DEPEND="dev-python/setuptools"
RDEPEND=""
S="${WORKDIR}/${PN}"

src_install() {
	distutils_src_install
	use doc && dohtml doc/*html doc/*css
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/redis
}
