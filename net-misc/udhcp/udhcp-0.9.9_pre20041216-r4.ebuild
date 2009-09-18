# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/udhcp/udhcp-0.9.9_pre20041216-r4.ebuild,v 1.2 2007/03/28 06:13:08 vapier Exp $

inherit multilib eutils toolchain-funcs

DESCRIPTION="udhcp Server/Client Package"
HOMEPAGE="http://udhcp.busybox.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc sparc x86"
IUSE=""

DEPEND="virtual/libc"
PROVIDE="virtual/dhcpc"

S="${WORKDIR}/${PN}"

pkg_setup() {
	enewgroup dhcp
	enewuser dhcp -1 -1 /var/lib/dhcp dhcp
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# This patch adds the --env,-e option to udhcpc so we can pass the dhcp
	# client some environment variables to pass to the script. We do this so
	# the script knows mertric and whether to setup DNS, NTP and routers.
	epatch "${FILESDIR}/${P}"-env.patch
}

src_compile() {
	emake \
		CROSS_COMPILE=${CHOST}- \
		STRIP=true \
		UDHCP_SYSLOG=1 \
		|| die
}

src_install() {
	emake STRIP=true install DESTDIR="${D}" USRSBINDIR="${D}/sbin" || die
	newinitd "${FILESDIR}"/udhcp.rc udhcp
	insinto /etc
	doins samples/udhcpd.conf
	dodoc AUTHORS ChangeLog README* TODO
	newdoc samples/README README.scripts

	# udhcpc setup script - the supplied ones don't work
	# This does it supports resolvconf, metrics and whether to setup
	# dns, ntp and routers. Requires the --env patch above.
	exeinto /$(get_libdir)/rcscripts/sh
	newexe "${FILESDIR}"/udhcpc.sh udhcpc.sh
}
