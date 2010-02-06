# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

DESCRIPTION="which.py is a small GNU-which replacement."
HOMEPAGE="http://code.google.com/p/which/"
SRC_URI="http://which.googlecode.com/files/${P}.zip"
RESTRICT="nomirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}"
