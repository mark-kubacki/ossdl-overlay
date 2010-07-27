# Copyright 2006-2008 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 arm ~sparc x86"
IUSE=""

# Apache 2.2* crashes with MySQL support build in APR-Util

RDEPEND="
	sys-meta/sys-base
	>=virtual/mysql-5.1
	>=www-servers/apache-2.2.12
	>=www-servers/nginx-0.8.7
	>=www-apache/mod_macro-1.1.10
	>=dev-lang/php-5.2.10
	dev-php/PEAR-PEAR
	dev-php5/eaccelerator
	dev-php5/pecl-fileinfo
	dev-php5/pecl-idn
	>=dev-vcs/subversion-1.6.3
	>=net-misc/memcached-1.4.0
	>=net-misc/spread-1.4.0
	"
