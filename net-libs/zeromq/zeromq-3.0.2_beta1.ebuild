# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI="2"
inherit flag-o-matic

MY_P=${P/_/-}
MY_P=${MY_P/beta1/beta}

DESCRIPTION="ØMQ is a lightweight messaging implementation with a socket-like API"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="http://download.zeromq.org/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pgm +pic"

RDEPEND="dev-libs/glib
	sys-apps/util-linux
	arm? ( pgm? ( net-libs/openpgm ) )
	"
DEPEND="${RDEPEND}
	"

S="${WORKDIR}/${P/_beta[0-9]/}"

src_configure() {
	local myconf=
	if use arm; then
		use pgm		&& myconf+=" $(use_with system-pgm)"
	else
		use pgm		&& myconf+=" $(use_with pgm)"
	fi
	myconf+=" $(use_with pic)"

	filter-flags -combine -fwhole-program -fwhopr
	econf ${myconf} || die "econf"
}

src_compile() {
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"
}
