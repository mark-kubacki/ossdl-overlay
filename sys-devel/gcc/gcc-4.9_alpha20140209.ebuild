# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS=1

MY_PV="${PV%%_*}"
MY_PRE="${PV##*_alpha}"
MY_PRE="${MY_PRE%%_*}"
MY_P="${PN}-${MY_PV}-${MY_PRE}"
G_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

EPATCH_SOURCE="${FILESDIR}/${PV}"
EPATCH_EXCLUDE="${FILESDIR}/${PV}/exclude"
EPATCH_SUFFIX="patch"

# Hardened gcc 4 stuff
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 mips ppc ppc64 arm ia64"
PIE_UCLIBC_STABLE="x86 arm amd64 mips ppc ppc64"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"
# uclibc need tls and nptl support for SSP support
# uclibc need to be >= 0.9.33
SSP_UCLIBC_STABLE="x86 amd64 mips ppc ppc64 arm"
#end Hardened stuff

inherit eutils toolchain

DESCRIPTION="The GNU Compiler Collection"
GCC_SRC_URI="mirror://gcc/snapshots/${MY_PV}-${MY_PRE}/${MY_P}.tar.bz2"

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"

KEYWORDS="~amd64 ~amd64-linux"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	>=${CATEGORY}/binutils-2.20"
#	amd64? ( multilib? ( gcj? ( app-emulation/emul-linux-x86-xlibs ) ) )

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.12 )"
fi

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0
	#Use -r1 for newer piepatchet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env-r1.patch
}
