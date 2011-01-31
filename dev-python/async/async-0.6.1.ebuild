# Copyright 2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4:2.7"

inherit distutils python

DESCRIPTION="A framework to process interdependent tasks in a pool of workers."
HOMEPAGE="http://gitorious.org/git-python/async http://packages.python.org/async"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools
	${RDEPEND}"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}
