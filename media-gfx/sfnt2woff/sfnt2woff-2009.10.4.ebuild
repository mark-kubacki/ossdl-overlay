# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Very small utility to convert font files to WOFF"
HOMEPAGE="http://people.mozilla.com/~jkew/woff/"
SRC_URI="http://people.mozilla.com/~jkew/woff/woff-code-latest.zip"
RESTRICT="primaryuri"

LICENSE="( GPL-2 BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86 ~arm"
IUSE=""

S="${WORKDIR}/woff-code-latest"

src_compile() {
	emake || die "Failed compiling ttf2eot."
}

src_install() {
	exeinto /usr/bin
	doexe sfnt2woff
	doexe woff2sfnt
}