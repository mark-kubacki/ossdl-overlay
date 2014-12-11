# Copyright 1999-2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

BINUTILS_TYPE="git"
EGIT_BRANCH="binutils-2_25-branch"
EGIT_COMMIT="516a3acf86bb85b0e51c9809a93d3b50320b6bde"
BVER="2.25.0.0.${PV##*_pre}"

inherit toolchain-binutils

KEYWORDS="~amd64 ~arm64 ~x86"

src_prepare() {
	toolchain-binutils_src_prepare

	sed -i -e "s:2.24.90:2.25.0.0.${PV##*_pre}:" -- */configure bfd/version.m4 \
	|| die "cannot set version"
}
