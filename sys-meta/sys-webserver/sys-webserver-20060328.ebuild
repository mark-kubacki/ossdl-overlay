# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=sys-meta/sys-base-${PV}
	>=virtual/mysql-5.0.18
	>=net-www/apache-2.2.0
	>=dev-python/mod_python-3.2.8
	>=dev-lang/php-5.1*
	net-ftp/vsftpd
	>=dev-vcs/subversion-1.2.3
	"
