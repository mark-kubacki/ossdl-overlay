# Copyright 1999-2010 Gentoo Foundation, 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit distutils

KEYWORDS="amd64 x86 arm"
DESCRIPTION="Command line client for Amazon S3"
HOMEPAGE="http://s3tools.org/s3cmd"
SRC_URI="http://binhost.ossdl.de/distfiles/${P}.tar.lzma"
LICENSE="GPL-2"
RESTRICT="primaryuri"

IUSE=""
SLOT="0"

RDEPEND=">=dev-lang/python-2.4
	dev-python/elementtree"

src_install() {
	S3CMD_INSTPATH_DOC=/usr/share/doc/${PF} distutils_src_install
}
