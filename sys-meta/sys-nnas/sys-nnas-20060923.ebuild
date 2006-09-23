# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Meta package for NNAS installations."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE=""

# Apache 2.2* crashes with MySQL support build in APR-Util

RDEPEND="
	>=sys-meta/sys-base-${PV}
	net-fs/samba
	net-ftp/lftp
	sys-apps/smartmontools
	sys-fs/cryptsetup-luks
	sys-fs/lvm2
	sys-power/acpid
	"
