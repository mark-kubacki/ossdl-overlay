# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="datastudio"
S=${WORKDIR}/${MY_PN}
DESCRIPTION="Aqua Data Studio provides an integrated database environment with a single consistent interface to all major relational databases."
HOMEPAGE="http://www.aquafold.com/"
SRC_URI="http://aquafold.fileburst.com/download/v${PV}/linux/ads-linux-x86-${PV}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="!amd64? (
			>=dev-libs/glib-2
			>=x11-libs/pango-1.2
			>=x11-libs/gtk+-2.2
	)
	amd64? ( app-emulation/emul-linux-x86-gtklibs )
	"
RDEPEND="${DEPEND}
	virtual/x11
	"
RESTRICT="nostrip nomirror"

src_install() {
	dodir /opt/${MY_PN}
	mv * ${D}/opt/${MY_PN} || die

	dodir /usr/bin
	dosym /opt/${MY_PN}/datastudio-bundled.sh /usr/bin/ads

	domenu ${FILESDIR}/aquadatastudio.desktop
}
