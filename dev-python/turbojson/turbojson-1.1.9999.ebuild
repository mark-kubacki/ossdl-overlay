# Copyright 2008 OSSDL.de
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils subversion

KEYWORDS="~amd64 ~x86"

MY_PN=TurboJson
MY_P=${MY_PN}-${PV}

DESCRIPTION="TurboGears JSON file format support plugin"
HOMEPAGE="http://www.turbogears.org/docs/plugins/template.html"
ESVN_REPO_URI="http://svn.turbogears.org/projects/TurboJson/branches/1.1"
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
