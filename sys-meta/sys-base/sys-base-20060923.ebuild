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
	app-admin/sudo
	app-admin/syslog-ng
	app-arch/lzop
	app-crypt/gnupg
	app-misc/mc
	app-misc/screen
	app-portage/eix
	app-portage/gentoolkit
	app-shells/bash-completion
	app-shells/bash-completion-config
	app-text/tree
	net-analyzer/netcat
	net-ftp/ncftp
	sys-apps/acl
        sys-boot/grub
        sys-fs/xfsprogs
	sys-fs/jfsutils
        >=sys-process/fcron-3.0.1
        !no-net? ( net-dns/bind-tools )
        !no-net? ( net-firewall/iptables ) 
	!no-net? ( net-ftp/ncftp )
        !no-net? ( net-misc/dhcpcd )
        !no-net? ( net-misc/ntp )
	"
