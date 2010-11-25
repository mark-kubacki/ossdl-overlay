# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit distutils

MY_PN="python-monetdb"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for MonetDB"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://dev.monetdb.org/downloads/sources/Oct2010/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools
	${RDEPEND}"

PYTHON_MODNAME=$MY_PN
S="${WORKDIR}/${MY_P}"

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/monetdb
}
