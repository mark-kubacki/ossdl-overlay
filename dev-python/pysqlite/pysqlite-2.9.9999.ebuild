# Copyright 1999-2007 OSSDL.de
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="*:2.4"

inherit distutils subversion

MY_PN=pysqlite
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python wrapper for the local database Sqlite"
HOMEPAGE="http://initd.org/tracker/pysqlite/"
ESVN_REPO_URI="http://initd.org/svn/pysqlite/pysqlite/trunk"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="pysqlite"
SLOT="2"
IUSE="examples"

DEPEND=">=dev-db/sqlite-3.1"

PYTHON_MODNAME="pysqlite2"
S=${WORKDIR}/${MY_P}

src_unpack() {
	subversion_src_unpack

	# don't install pysqlite2.test
	sed -i -e 's/, "pysqlite2.test"//' \
		setup.py || die "sed in setup.py failed"
	# workaround to make checks work without installing them
	sed -i -e "s/pysqlite2.test/test/" \
		pysqlite2/test/__init__.py || die "sed failed"
	# correct encoding
	sed -i -e "s/\(coding: \)ISO-8859-1/\1utf-8/" \
		pysqlite2/__init__.py pysqlite2/dbapi2.py || die "sed failed"
	# patch for conn string
}

src_install() {
	DOCS="doc/usage-guide.txt"
	distutils_src_install

	rm -rf "${D}"/usr/pysqlite2-doc

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r doc/code
	fi
}

src_test() {
	cd pysqlite2
	# tests use this as a nonexistant file
	addpredict /foo/bar
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" -c \
		"from test import test;import sys;sys.exit(test())" \
		|| die "test failed"
}
