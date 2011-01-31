# Copyright 2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.4:2.7"

inherit distutils

MY_PN="GitPython"
MY_P="${MY_PN}-${PV/_/-}"
PYTHON_MODNAME="git"

DESCRIPTION="A python library used to interact with Git repositories."
HOMEPAGE="http://gitorious.org/projects/git-python/ http://packages.python.org/GitPython"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="primaryuri"

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
