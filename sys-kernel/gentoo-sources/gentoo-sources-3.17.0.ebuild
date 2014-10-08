# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"
K_DEBLOB_AVAILABLE="1"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
        kernel-2_src_prepare
        epatch \
		${FILESDIR}/3.17/0001-Jitterentropy-20140411.patch \
		${FILESDIR}/3.17/0002-Jitterentropy-20140411-fix-for-3.16.patch \
		${FILESDIR}/3.17/0003-Reduce-cache-pressure-and-swappiness.patch \
		${FILESDIR}/3.17/0004-IPv6-use-tempaddr-by-default.patch \
		${FILESDIR}/3.17/0005-prevent-signing-keys-from-being-accidentally-overwri.patch \
		${FILESDIR}/3.17/tcp_stealth_3.16_1.diff
	epatch ${FILESDIR}/3.17/rc7/3.17-rc7.overlayfs.v24.patch
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
