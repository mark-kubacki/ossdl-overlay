# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=4

inherit git-2 eutils

DESCRIPTION="Key-value storage library that provides an ordered mapping from string keys to string values"
HOMEPAGE="http://code.google.com/p/leveldb/"
EGIT_REPO_URI="https://code.google.com/p/leveldb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE="+snappy tcmalloc"

DEPEND="snappy? ( app-arch/snappy )
	tcmalloc? ( dev-util/google-perftools )
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	use snappy && export EXTRA_EMAKE="${EXTRA_EMAKE} USE_SNAPPY=yes"
	use tcmalloc && export EXTRA_EMAKE="${EXTRA_EMAKE} USE_GOOGLE_PERFTOOLS=yes"
}

src_prepare(){
	sed -i	-e 's:OPT ?=:OPT ?= -fPIC:g' \
		"${S}/Makefile"
}

src_install(){
	dodir /usr/include/
	cp -R "${S}/include/" "${D}/usr/" || die
	dodir /usr/lib/
	cp "${S}/libleveldb.a" "${D}/usr/lib/" || die
}
