# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4:2.7"

inherit distutils

DESCRIPTION="A scalable, non-blocking web server."
HOMEPAGE="http://mark.ossdl.de/tags/anzu"
SRC_URI="http://github.com/downloads/wmark/${PN}/${P}.tar.lzma"
RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

RDEPEND=">=dev-python/formencode-1.2.2
	>=dev-python/mako-0.2.5
	dev-python/simplejson
	>=dev-python/pycurl-7.19.0
	dev-python/murmur"
DEPEND="${DEPEND}
	dev-python/setuptools
	"

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/anzu
}
