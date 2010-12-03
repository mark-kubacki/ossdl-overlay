# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit distutils

DESCRIPTION="Python bindings to the Tokyo Cabinet database library; clone of dev-db/pytc"
HOMEPAGE="http://blog.hunch.se/2009/03/02-tokyo-cabinet-python-bindings
	http://github.com/rsms/tc"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND=">=dev-db/tokyocabinet-1.3.19"
RDEPEND="${DEPEND}"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}
