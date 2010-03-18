# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOCONF="latest"

inherit autotools eutils

DESCRIPTION="Simple FastCGI wrapper for CGI scripts"
HOMEPAGE="http://github.com/gnosek/fcgiwrap/"
SRC_URI=""
EGIT_REPO_URI="http://github.com/gnosek/fcgiwrap.git"
RESTRICT="fetch"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND="dev-libs/fcgi"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	>=sys-devel/autoconf-2.63
	dev-vcs/git"

pkg_nofetch() {
	cd "${WORKDIR}"
	git clone "${EGIT_REPO_URI}" "${P}"
	cd "${S}"

	cp "${FILESDIR}"/configure.ac-1.00 configure.ac
	mv Makefile Makefile.in
	sed -i	-e 's:gcc:@CC@:g' \
		-e 's:-std=gnu99 -Wall -Wextra -Werror -pedantic -O2 -g3:@AM_CFLAGS@:g' \
		Makefile.in \
	|| die "Sed failed!"

	eautoconf
}

src_unpack() {
	pkg_nofetch
}

src_install() {
	dosbin fcgiwrap
}
