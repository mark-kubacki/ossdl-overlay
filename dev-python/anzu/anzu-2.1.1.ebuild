# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

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
	>=dev-python/pycurl-7.19.0
	dev-python/murmur"
DEPEND="${DEPEND}
	dev-python/setuptools
	"

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/anzu
}
