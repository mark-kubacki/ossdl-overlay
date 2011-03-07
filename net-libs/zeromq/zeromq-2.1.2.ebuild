# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="ØMQ is a lightweight messaging implementation with a socket-like API"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="+pgm +pic"

RDEPEND="dev-libs/glib
	sys-apps/util-linux
	"
DEPEND="${RDEPEND}
	"

src_configure() {
	local myconf=
	if use arm; then
		use pgm		&& ewarn "PGM doesn't work on ARM. USE flag will be ignored."
	else
		use pgm		&& myconf+=" $(use_with pgm)"
	fi
	myconf+=" $(use_with pic)"

	econf ${myconf} || die "econf"
}

src_compile() {
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"
}
