# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="amd64 x86"

MY_PN=TurboJson
MY_P=${MY_PN}-${PV}

DESCRIPTION="TurboGears JSON file format support plugin"
HOMEPAGE="http://www.turbogears.org/docs/plugins/template.html"
SRC_URI="http://pypi.python.org/packages/source/T/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/ruledispatch
	dev-python/simplejson"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/nose )"

S=${WORKDIR}/${MY_P}

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}
