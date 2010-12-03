# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit distutils

DESCRIPTION="Tokyo Cabinet Python bindings"
HOMEPAGE="http://coderepos.org/share/browser/lang/python/pytc"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND=">=dev-db/tokyocabinet-1.3.19"
RDEPEND="${DEPEND}"
