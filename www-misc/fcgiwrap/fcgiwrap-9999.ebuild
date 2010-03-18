# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Simple FastCGI wrapper for CGI scripts"
HOMEPAGE="http://github.com/gnosek/fcgiwrap/"
SRC_URI=""
EGIT_REPO_URI="http://github.com/gnosek/fcgiwrap.git"
RESTRICT="fetch"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

DEPEND="dev-libs/fcgi"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-vcs/git"

pkg_nofetch() {
	cd "${WORKDIR}"
	git clone "${EGIT_REPO_URI}" "${P}"
}

src_unpack() {
	pkg_nofetch
}

src_configure() {
	true
}

src_install() {
	dosbin fcgiwrap
}
