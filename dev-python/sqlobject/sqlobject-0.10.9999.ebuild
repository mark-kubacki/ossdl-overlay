# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.2

inherit distutils subversion

MY_PN=SQLObject
MY_P=${MY_PN}-${PV}

DESCRIPTION="Object-relational mapper for Python"
HOMEPAGE="http://sqlobject.org/"
ESVN_REPO_URI="http://svn.colorstudy.com/SQLObject/branches/0.10"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="postgres mysql sqlite firebird doc"

RDEPEND="postgres? ( dev-python/psycopg )
		mysql? ( >=dev-python/mysql-python-1.2.2 )
		sqlite? ( <dev-python/pysqlite-2.0 )
		firebird? ( >=dev-python/kinterbasdb-3.0.2 )
		>=dev-python/formencode-0.2.2"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S=${WORKDIR}/${MY_P}

src_unpack() {
	subversion_src_unpack

	cd "${S}"

	epatch "${FILESDIR}/UnicodeStringValidator.patch"

	sed -i \
		-e '/use_setuptools/d' \
		-e '/install_requires=/d' \
		-e '/extras_require/, /},/d' \
		setup.py || die "sed failed"
}

src_install() {
	distutils_src_install

	if use doc; then
		cd "${S}/docs"
		dodoc *.txt
		dohtml -r presentation-2004-11
		insinto /usr/share/doc/${PF}
		doins -r europython
	fi
}
