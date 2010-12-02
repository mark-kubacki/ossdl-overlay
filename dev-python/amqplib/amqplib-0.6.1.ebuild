# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit distutils

DESCRIPTION="Client library for AMQP (Advanced Message Queuing Protocol)"
HOMEPAGE="http://code.google.com/p/py-amqplib/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tgz"
RESTRICT="primaryuri"

LICENSE="LGPL"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools
	${RDEPEND}"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}
