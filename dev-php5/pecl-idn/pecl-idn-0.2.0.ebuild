# Copyright 1999-2006 Gentoo Foundation
# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

PHP_EXT_NAME="idn"
PHP_EXT_PECL_PKG="idn"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-3 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="amd64 hppa ppc ppc64 sparc x86"

DESCRIPTION="Binding to the GNU libidn for using Internationalized Domain Names."
LICENSE="PHP"
SLOT="0"
IUSE=""

DEPEND="net-dns/libidn"
RDEPEND="${DEPEND}"
