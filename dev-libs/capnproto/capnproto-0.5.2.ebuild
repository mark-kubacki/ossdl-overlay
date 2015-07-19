# Copyright 2015 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"

inherit eutils autotools-multilib

DESCRIPTION="serialization library, like protobuf"
HOMEPAGE="https://capnproto.org/"
SRC_URI="https://capnproto.org/${PN}-c++-${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86"

RDEPEND=""
DEPEND=">=sys-devel/gcc-4.8.0"

S="${WORKDIR}/${PN}-c++-${PV}"

src_prepare() {
	sed -i \
		-e '/^\s*ldconfig/d' \
		Makefile.am || die
	eautoreconf
}
