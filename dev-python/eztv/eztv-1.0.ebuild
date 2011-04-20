# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"

inherit distutils

DESCRIPTION="A python interface to eztv dot it"
HOMEPAGE="http://hg.sobber.org/eztv"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
KEYWORDS="amd64 x86 arm ppc hpa sparc"
IUSE=""
SLOT="0"

RDEPEND="dev-python/lxml
	"
DEPEND="dev-python/setuptools
	"

pkg_postinst() {
	python_mod_optimize eztv
}
