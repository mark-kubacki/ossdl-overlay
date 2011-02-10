# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOCONF="latest"

inherit autotools eutils

DESCRIPTION="Simple FastCGI wrapper for CGI scripts"
HOMEPAGE="http://github.com/wmark/fcgiwrap/"
SRC_URI="https://download.github.com/gnosek-fcgiwrap-v1.0.1-0-g9db989a.tar.gz"
RESTRICT="primaryuri"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND="dev-libs/fcgi"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	>=sys-devel/autoconf-2.63
	dev-vcs/git"

S="${WORKDIR}/gnosek-fcgiwrap-f56c85c"

src_prepare() {
	eautoreconf -i
}

src_install() {
	dosbin fcgiwrap
	doman fcgiwrap.8
}
