# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

DESCRIPTION="Find path to python modules from the command line."
HOMEPAGE="http://pypi.python.org/pypi/pywhich/1.0.1"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}"
