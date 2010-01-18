# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.33_pre20090721.ebuild,v 1.2 2009/08/24 15:42:30 hollow Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A minimal libc"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="http://www.kernel.org/pub/linux/libs/dietlibc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

DIETHOME=/usr/diet

pkg_setup() {
	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# debug flags
	use debug && append-flags -g

	# Makefile does not append CFLAGS
	append-flags -nostdinc -W -Wall -Wextra -Wchar-subscripts \
		-Wmissing-prototypes -Wmissing-declarations -Wno-switch \
		-Wno-unused -Wredundant-decls
}

src_compile() {
	emake prefix=${DIETHOME} CC="$(tc-getCC)" CFLAGS="${CFLAGS}" -j1 || die "make failed"
}

src_install() {
	emake prefix=${DIETHOME} DESTDIR="${D}" -j1 install || die "make install failed"
	dobin "${D}"${DIETHOME}/bin/* || die "dobin failed"
	doman "${D}"${DIETHOME}/man/*/* || die "doman failed"
	rm -r "${D}"${DIETHOME}/{man,bin}
	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING
}
