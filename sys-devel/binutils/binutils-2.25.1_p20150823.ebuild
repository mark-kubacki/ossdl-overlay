# Copyright 1999-2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

BINUTILS_TYPE="git"
EGIT_BRANCH="binutils-2_25-branch"
EGIT_COMMIT="0363588f454f6efa3dab47c932b488d33a45eb70"
BVER="2.25.1.${PV##*_p}"

inherit toolchain-binutils

KEYWORDS="~amd64 ~arm64 ~x86"

src_prepare() {
	toolchain-binutils_src_prepare

	sed -i -e "s:2.25.2:${BVER}:" -- */configure bfd/version.m4 \
	|| die "cannot set version"
}
