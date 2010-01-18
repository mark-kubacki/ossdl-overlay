# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_EXT_NAME="idn"
PHP_EXT_PECL_PKG="idn"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
DESCRIPTION="Binding to the GNU libidn for using Internationalized Domain Names."
LICENSE="PHP"
SRC_URI="http://pecl.php.net/get/idn-${PV}.tgz"
RESTRICT="nomirror"
SLOT="0"
IUSE=""

DEPEND="${DEPEND}
	net-dns/libidn"

need_php_by_category
