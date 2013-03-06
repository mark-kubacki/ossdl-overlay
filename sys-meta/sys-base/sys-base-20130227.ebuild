# Copyright 2006-2013 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

DESCRIPTION="do not merge this yourself, this will be the base of a specific system configuration"
HOMEPAGE="http://mark.ossdl.de/"
RESTRICT="bindist"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 arm sparc x86"
IUSE="no-net +raid"

RDEPEND="
	app-admin/logrotate
	app-admin/showconsole
	app-admin/sudo
	app-admin/syslog-ng
	app-admin/sysstat
	sys-apps/dstat
	sys-apps/pv
	app-arch/lzop
	app-crypt/gnupg
	app-misc/colordiff
	app-misc/screen
	app-misc/tmux
	app-portage/eix
	app-portage/gentoolkit
	app-portage/mirrorselect
	app-portage/portage-utils
	app-shells/bash-completion
	app-text/tree
	=dev-lang/python-2.7*
	dev-util/ccache
	sys-apps/ack
	sys-fs/btrfs-progs
        >=sys-process/fcron-3.0.1
	sys-process/htop
	sys-process/iotop
	|| ( net-analyzer/netcat6 net-analyzer/netcat )
	!arm? (
		sys-boot/grub-static
		sys-power/acpid
		sys-power/cpufrequtils
	)
        !no-net? (
		net-dns/bind-tools
        	net-firewall/iptables
		|| (
			net-ftp/ncftp
			net-ftp/lftp
		)
        	net-misc/ntp
		net-misc/gwhois
		sys-apps/iproute2
		net-dns/pdns-recursor
	)
	raid? (
		sys-apps/raidutils
		<sys-apps/smartmontools-9999
		sys-fs/dmraid
		sys-fs/lvm2
	)
	"
