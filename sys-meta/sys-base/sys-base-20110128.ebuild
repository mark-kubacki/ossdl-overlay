# Copyright 2006-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

DESCRIPTION="do not merge this yourself, this will be the base of a specific system configuration"
HOMEPAGE="http://www.ossdl.de/"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 arm sparc x86"
IUSE="no-net +raid"

RDEPEND="
	app-admin/logrotate
	app-admin/showconsole
	app-admin/sudo
	app-admin/syslog-ng
	app-arch/lzop
	app-crypt/gnupg
	app-misc/colordiff
	app-misc/mc
	app-misc/screen
	app-portage/eix
	app-portage/gentoolkit
	app-portage/mirrorselect
	app-portage/portage-utils
	app-shells/bash-completion
	app-text/tree
	=dev-lang/python-2.7*
	dev-util/ccache
	|| ( net-analyzer/netcat6 net-analyzer/netcat )
	!arm? (
		sys-power/acpid
		sys-power/cpufrequtils
	)
	sys-process/htop
	sys-process/iotop
	net-ftp/ncftp
	sys-apps/smartmontools
        sys-fs/xfsprogs
        >=sys-process/fcron-3.0.1
	sys-process/htop
        !no-net? (
		net-dns/bind-tools
        	net-firewall/iptables
		net-fs/nfs-utils
		net-ftp/ncftp
        	net-misc/udhcp
        	net-misc/ntp
		net-misc/gwhois
		sys-apps/iproute2
	)
	raid? (
		sys-apps/raidutils
		sys-fs/dmraid
		sys-fs/lvm2
	)
	"
