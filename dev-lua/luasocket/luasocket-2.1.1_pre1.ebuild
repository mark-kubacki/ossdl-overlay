# Copyright 1999-2012 Gentoo Foundation
# Copyright 2013 Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit multilib toolchain-funcs flag-o-matic eutils git-2

DESCRIPTION="Networking support library for the Lua language."
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
EGIT_REPO_URI="http://github.com/diegonehab/luasocket.git"
EGIT_COMMIT="ca48baf495d57a592030db82d5e4407596f0afde"
EGIT_BRANCH="unstable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE="debug"

RDEPEND=">=dev-lang/lua-5.1[deprecated]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Unix socket support is needed by app-crypt/ekeyd, but upstream
	# does not seem to enable it by default.
	epatch "${FILESDIR}"/${P}-unixsocket.patch
}

src_compile() {
	# We append flags here to avoid editing the config file
	use debug && append-flags -DLUASOCKET_DEBUG
	# append-flags strips quotation marks, therefore -DLUASOCKET_API and -DMIME_API cannot be added here!
	append-flags -fPIC -DLUASOCKET_NODEBUG -DLUA_COMPAT_MODULE -fvisibility=hidden

	emake \
		CFLAGS="${CFLAGS} -DLUASOCKET_API='__attribute__((visibility(\"default\")))' -DMIME_API='__attribute__((visibility(\"default\")))'" \
		LDFLAGS="${LDFLAGS} -o" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		|| die
}

src_install() {
	emake install-unix \
		INSTALL_TOP_SHARE="${D}/$(pkg-config --variable INSTALL_LMOD lua)" \
		INSTALL_TOP_LIB="${D}/$(pkg-config --variable INSTALL_CMOD lua | sed -e "s:lib/:$(get_libdir)/:")" \
		|| die

	dodoc NEW README || die
	dohtml doc/* || die
}
