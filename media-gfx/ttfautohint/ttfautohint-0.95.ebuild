# Copyright 2003 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
inherit qt4-r2

DESCRIPTION="A library to autohint TrueType fonts"
HOMEPAGE="http://www.freetype.org/ttfautohint/"
SRC_URI="mirror://sourceforge/freetype/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~arm"
IUSE="+qt"

DEPEND=">=media-libs/freetype-2.4.5
	qt? ( >=dev-qt/qtgui-4.8 )
	"

src_configure() {
	econf $(use_with qt)
}
