# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

EAPI="2"

DESCRIPTION="Python bindings for 0MQ"
HOMEPAGE="http://github.com/zeromq/pyzmq"
SRC_URI=""
EGIT_REPO_URI="http://github.com/zeromq/pyzmq.git"
EGIT_COMMIT="a36eda42ff8f6d01e71df1b366caed1e8286bb9c"
RESTRICT="fetch"

LICENSE="LGPL GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="|| ( =net-libs/zeromq-2.0* =net-libs/zeromq-2.1* )"
DEPEND="${RDEPEND}
	dev-vcs/git"

pkg_nofetch() {
	cd "${WORKDIR}"
	git clone "${EGIT_REPO_URI}" "${P}" || die "Source checkout failed."
	cd "${S}"
	git checkout -b "${PV}" "${EGIT_COMMIT}" || die "Cannot change to appropriate GIT state."
}

src_unpack() {
	pkg_nofetch

	mv setup.cfg.template setup.cfg
	sed -i \
		-e "s:/usr/local/zeromq-dev/lib:/usr/$(get_libdir):g" \
		-e "s:/usr/local/zeromq-dev/include:/usr/include:g" \
		setup.cfg || die "Cannot set library directory."
}

src_install() {
	distutils_src_install
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/zmq"
}
