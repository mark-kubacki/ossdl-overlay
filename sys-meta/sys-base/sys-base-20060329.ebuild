# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="do not merge this yourself, this will be the base of a specific system configuration"
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="no-net"

RDEPEND="
	app-admin/logrotate
	app-admin/syslog-ng
	app-shells/bash-completion
	app-shells/bash-completion-config
	app-text/tree
	net-ftp/ncftp
        sys-boot/grub
        sys-fs/xfsprogs
        >=sys-process/fcron-3.0.0
        !no-net? ( net-dns/bind-tools )
        !no-net? ( net-firewall/iptables ) 
	!no-net? ( net-ftp/ncftp )
        !no-net? ( net-misc/dhcpcd )
        !no-net? ( net-misc/ntp )
	"
