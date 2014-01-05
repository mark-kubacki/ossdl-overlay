# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Very small utility to convert font files to WOFF"
HOMEPAGE="http://people.mozilla.com/~jkew/woff/"
SRC_URI="http://people.mozilla.com/~jkew/woff/woff-code-latest.zip -> sfnt2woff-2009.10.04.zip"
RESTRICT="primaryuri"

LICENSE="( GPL-2 BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

S="${WORKDIR}"

src_compile() {
	emake || die "Failed compiling ttf2eot."
}

src_install() {
	dobin sfnt2woff
	dobin woff2sfnt
}