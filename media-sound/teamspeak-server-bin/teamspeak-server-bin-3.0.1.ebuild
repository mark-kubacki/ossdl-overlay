# Copyright 1999-2011 Gentoo Foundation
# Copyright 2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils

DESCRIPTION="TeamSpeak Server - Voice Communication Software"
HOMEPAGE="http://teamspeak.com/"
LICENSE="teamspeak3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"
RESTRICT="strip primaryuri mirror bindist"

SRC_URI="
	amd64? ( http://teamspeak.gameserver.gamed.de/ts3/releases/${PV}/teamspeak3-server_linux-amd64-${PV}.tar.gz )
	x86? ( http://teamspeak.gameserver.gamed.de/ts3/releases/${PV}/teamspeak3-server_linux-x86-${PV}.tar.gz )
"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser teamspeak3
}

src_install() {
	local dest="${D}/opt/teamspeak3-server"

	mkdir -p "${dest}"
	cp -R "${WORKDIR}/teamspeak3-server_linux-"*/* "${dest}/" || die

	mv "${dest}/ts3server_linux_"* "${dest}/ts3server-bin" || die

	exeinto /usr/sbin || die
	doexe "${FILESDIR}/ts3server" || die

	# runtime FS layout ...
	insinto /etc/teamspeak3-server
	doins "${FILESDIR}/server.conf"
	newinitd "${FILESDIR}/teamspeak3-server.rc" teamspeak3-server

	keepdir /{etc,var/{lib,log,run}}/teamspeak3-server
	fowners teamspeak3 /{etc,var/{lib,log,run}}/teamspeak3-server
	fperms 700 /{etc,var/{lib,log,run}}/teamspeak3-server

	fowners teamspeak3 /opt/teamspeak3-server
	fperms 755 /opt/teamspeak3-server
}

pkg_postinst() {
	einfo "After having started Teamspeak the first time,"
	einfo "you can find the 'ServerAdmin privilege key' by:"
	einfo "# grep -oh 'token=.*' /var/log/teamspeak3-server/ts3server_*.log"
	einfo ""
	einfo "If you have a license key, paste it into (creating that file):"
	einfo "/opt/teamspeak3-server/licensekey.dat"
	einfo "... or change 'licensepath' in /etc/teamspeak3-server/server.conf"
	einfo ""
	einfo "If you want to run any of TS's binaries, prepend this to the command:"
	einfo "# export LD_LIBRARY_PATH=\"/opt/teamspeak3-server:$LD_LIBRARY_PATH\""
}