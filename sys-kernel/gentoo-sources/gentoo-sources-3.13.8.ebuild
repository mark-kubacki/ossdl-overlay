# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-3.13.7.ebuild,v 1.1 2014/03/24 13:55:00 tomwij Exp $

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="11"
K_DEBLOB_AVAILABLE="1"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	kernel-2_src_prepare
	epatch ${FILESDIR}/3.13/linux-3.13-cryptodev-1.6.patch
	epatch ${FILESDIR}/3.13/cryptodev-linux-01-Replace_INIT_COMPLETION_with_reinit_completion.patch
	epatch ${FILESDIR}/3.13/0001-jitterentropy-20140220.patch
	epatch ${FILESDIR}/3.13/0002-reduce-cache-pressure-and-swappiness.patch
	epatch ${FILESDIR}/3.13/0003-IPv6-use-tempaddr-by-default.patch
	epatch ${FILESDIR}/3.13/0004-GCC-expand-the-number-of-microarchitectures.patch
	epatch ${FILESDIR}/3.13/0005-prevent-signing-keys-from-being-accidentally-overwritten.patch
	epatch ${FILESDIR}/3.13/0001-known-exploit-detection.patch

	#epatch ${FILESDIR}/ocf/0001-ocf-linux-20120127-ocf-ocf-linux-3.patch.patch
	#epatch ${FILESDIR}/ocf/0002-update-ocf-patches.patch
	#epatch ${FILESDIR}/ocf/0003-ocf-add-missing-dependency-for-hifn-driver.patch
}

src_install() {
	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
