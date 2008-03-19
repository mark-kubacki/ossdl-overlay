# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils subversion

MY_PN="FormEncode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HTML form validation, generation, and conversion package"
HOMEPAGE="http://formencode.org/"
ESVN_REPO_URI="http://svn.colorstudy.com/FormEncode/tags/${PV}"

LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-python/setuptools"

PYTHON_MODNAME=$MY_PN
S="${WORKDIR}/${MY_P}"

src_unpack() {
	subversion_src_unpack

	cd "${S}"
}

src_install() {
	distutils_src_install

	dodoc docs/*.txt

	insinto /usr/share/doc/${PF}
	doins -r examples
}
