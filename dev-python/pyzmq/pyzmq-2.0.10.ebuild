# Copyright 2010-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

EAPI="2"

DESCRIPTION="Python bindings for 0MQ"
HOMEPAGE="http://github.com/zeromq/pyzmq"
SRC_URI="https://github.com/downloads/zeromq/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="|| ( ( >=net-libs/zeromq-2.0.10 <=net-libs/zeromq-2.0.999 ) =net-libs/zeromq-2.1* )"
DEPEND="${RDEPEND}
	"

src_prepare() {
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
