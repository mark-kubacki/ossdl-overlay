# Copyright 2011-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3*"

inherit eutils distutils

DESCRIPTION="A framework to process interdependent tasks in a pool of workers."
HOMEPAGE="http://gitorious.org/git-python/async http://packages.python.org/async"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""
SLOT="0"

RDEPEND="sys-libs/zlib"
DEPEND="dev-python/setuptools
	${RDEPEND}"

src_prepare() {
        distutils_src_prepare
        epatch "${FILESDIR}/${P}_libz_link.patch"
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}
