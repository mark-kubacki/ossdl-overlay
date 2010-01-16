# Copyright 1999-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_REDIS_PV="0.3.1"

inherit nginx

SLOT="0"
KEYWORDS="amd64 ppc x86 arm sparc ~x86-fbsd"

src_unpack() {
	nginx_src_unpack
	epatch "${FILESDIR}/nginx-0.8.27-zero_filesize_check.patch"
}
