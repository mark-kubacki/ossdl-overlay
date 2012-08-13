# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="*:2.4:3.2"

inherit distutils

DESCRIPTION="A template engine based on embedded Python."
HOMEPAGE="http://www.kuwata-lab.com/tenjin/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="tenjin"

pkg_postinst() {
	python_mod_optimize tenjin.py
}
