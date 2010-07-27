# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE=""

# Apache 2.2* crashes with MySQL support build in APR-Util

RDEPEND="
	sys-meta/sys-base
	>=virtual/mysql-5.0
	net-www/mod_auth_mysql
	=net-www/apache-2.0*
	>=dev-python/mod_python-3.2.8
	>=dev-lang/php-5.1.1
	dev-php5/eaccelerator
	dev-php5/pecl-fileinfo
	dev-php5/pecl-idn
	net-ftp/pure-ftpd
	>=dev-vcs/subversion-1.4.0
	"
