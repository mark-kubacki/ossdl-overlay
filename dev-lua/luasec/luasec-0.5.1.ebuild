# Copyright 2013 Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="fork of LuaSec for Prosody with some not-yet-released features of the official LuaSec"
HOMEPAGE="http://prosody.im/doc/depends/luasec/prosody"
SRC_URI="http://prosody.im/tmp/${PN}-prosody-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1[deprecated]
	>=dev-libs/openssl-1.0.1
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-prosody-${PV}"

src_prepare() {
	sed -i \
		-e "s#^LUAPATH.*#LUAPATH=$(pkg-config --variable INSTALL_LMOD lua)#" \
		-e "s#^LUACPATH.*#LUACPATH=$(pkg-config --variable INSTALL_CMOD lua)#" \
		Makefile || die
	sed -i -e "s/-O2//" src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" linux
}

src_install() {
	emake DESTDIR="${D}" install
}
