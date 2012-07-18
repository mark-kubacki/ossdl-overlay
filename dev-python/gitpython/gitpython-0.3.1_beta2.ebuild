# Copyright 2011-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.*"

inherit distutils

MY_PN="GitPython"
MY_P="${MY_PN}-${PV/_/-}"
PYTHON_MODNAME="git"

DESCRIPTION="A python library used to interact with Git repositories."
HOMEPAGE="http://gitorious.org/projects/git-python/ http://packages.python.org/GitPython"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE="+test"
SLOT="0"

RDEPEND=">=dev-vcs/git-1.7.0
	>=dev-python/gitdb-0.5.1
	"
DEPEND="dev-python/setuptools
	test? ( dev-python/mock dev-python/nose )
	${RDEPEND}"

S="${WORKDIR}/${MY_P%%\-beta[0-9]}"

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PYTHON_MODNAME}"
}
