# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI="3"
WANT_AUTOCONF="2.5"
inherit autotools flag-o-matic

DESCRIPTION="ØMQ is a lightweight messaging implementation with a socket-like API"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="+pgm pic test static-libs"

RDEPEND=""
RDEPEND="pgm? (
		dev-util/pkgconfig
		>=net-libs/openpgm-5.1.118
	)
	sys-apps/util-linux"

src_prepare() {
	if use pgm; then
		einfo "Removing bundled OpenPGM library"
		rm -r "${S}"/foreign/openpgm/libpgm* || die
		eautoreconf
	fi
}

src_configure() {
	local myconf
	use pgm && myconf+=" $(use_with system-pgm)" || myconf+=" --without-pgm"
	myconf+=" $(use_with pic)"

	# This flags either result in compilation errors
	# or byzantine runtime behaviour.
	filter-flags -combine -fwhole-program -fwhopr

	econf \
		$(use_enable static-libs static) \
		${myconf} || die "econf"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README AUTHORS ChangeLog || die "dodoc failed"
	doman doc/*.[1-9] || die "doman failed"

	# remove useless .la files
	find "${D}" -name '*.la' -delete

	# remove useless .a (only for non static compilation)
	use static-libs || find "${D}" -name '*.a' -delete
}
