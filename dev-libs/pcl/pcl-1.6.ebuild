# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A library to provide low-level coroutines for in-process context switching"
HOMEPAGE="http://www.xmailserver.org/libpcl.html"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"

# license not specified, but derived from GPL'd works
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"

IUSE=""

S="${WORKDIR}/lib${P}"

src_install() {
	emake DESTDIR="${D}" install || die "install"

	dodoc ChangeLog INSTALL
	dohtml man/pcl.html
}
