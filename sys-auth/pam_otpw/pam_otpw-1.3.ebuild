# Copyright 2010 W-Mark Kubacki; OSSDL
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils pam toolchain-funcs

MY_PN="${PN/pam_/}"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="a one-time password login package"
HOMEPAGE="http://www.cl.cam.ac.uk/~mgk25/otpw.html"
SRC_URI="http://www.cl.cam.ac.uk/~mgk25/download/${MY_PN}-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 arm"
IUSE=""

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}
	"

src_compile() {
	sed -i	-e "s:-O -ggdb -W -Wall:${CFLAGS} -Wall:" \
		-e "s:gcc:$(tc-getCC):" \
		-e "s:ld -:$(tc-getLD) -:" \
		Makefile \
	|| die "Sed failed!"

	emake || die
}

src_install() {
	dobin otpw-gen demologin
	dopammod pam_otpw.so

	dodoc README
	dohtml *.html
	doman otpw-gen.1 pam_otpw.8
}
