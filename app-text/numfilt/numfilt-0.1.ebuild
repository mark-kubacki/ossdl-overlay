# Copyright 2006-2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="translates numbers to words in ASCII text, such as '3rd' -> 'third'"
HOMEPAGE="http://www.gwdg.de/"
SRC_URI="ftp://ftp.gwdg.de/pub/linux/misc/text_to_speech/${P}.tar.gz"
RESTRICT="primaryuri,test"

LICENSE="NUMFILT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc-macos ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="sys-devel/gcc"
RDEPEND=""

src_compile() {
	epatch "${FILESDIR}"/0.1-main_warning.patch
	cc -Os numfilt.c -o numfilt
}

src_install() {
	dodoc README
	dobin numfilt
}
