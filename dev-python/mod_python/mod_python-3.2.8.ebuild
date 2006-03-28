# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils apache-module autotools

DESCRIPTION="An Apache2 DSO providing an embedded Python interpreter"
HOMEPAGE="http://www.modpython.org/"
SRC_URI="mirror://apache/httpd/modpython/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="apr-1-compat"
DEPEND=">=dev-lang/python-2.2.1"

APACHE2_MOD_CONF="${PVR}/16_mod_python"
APACHE2_MOD_DEFINE="PYTHON"

DOCFILES="README NEWS CREDITS NOTICE LICENSE"

need_apache2

export TEST_SERVER_ROOT="${T}/test"
export TEST_PYTHON_PATH="${TEST_SERVER_ROOT}/lib"
export TEST_USER="portage"
export TEST_GROUP="portage"

pkg_setup() {
    if ! use apr-1-compat && has_version ">=net-www/apache-2.2" ; then
	eerror "${P} as released upstream will not load with"
	eerror "apache-2.2, due to its use of a macro and accessor function"
	eerror "removed in apr-1.0. emerge with the apr-1-compat USE-flag"
	eerror "enabled to use ${PN} with apache-2.2."
	die "will not build against apache-2.2 without apr-1-compat USE-flag"
    fi
    apache-module_pkg_setup
}

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd ${S} || die "cd \$S failed"

	# remove optimisations, we do that outside portage
	sed -i -e 's:--optimize 2:--no-compile:' dist/Makefile.in

	# fix configure with bash 3.1
	# svn log -r376555 http://svn.apache.org/repos/asf
	epatch "${FILESDIR}/${PVR}/configure-bash-3.1.upstream.patch"

	# svn log -r376544 http://svn.apache.org/repos/asf
	if use apr-1-compat ; then
	    epatch "${FILESDIR}/${PVR}/apr-1.0-support.upstream.patch"
	fi    
	epatch "${FILESDIR}/${PVR}/apache-2.2-testing.upstream.patch"

	epatch "${FILESDIR}/${PVR}/gentoo-testing.patch"
	eautoconf
}

src_compile() {
	# TEST_* values will be substituted in test/testconf.py
	econf --with-apxs=${APXS2} || die "econf failed"

	emake OPT="`apxs2 -q CFLAGS` -fPIC" || die "emake failed"
}

src_test() {
	# tests need to be accessible to apache running as portage:portage
	cp -a test "${TEST_SERVER_ROOT}" \
	    || die "cannot populate test directory: ${TEST_SERVER_ROOT}"
	cd dist && python setup.py install -f --skip-build \
	    --install-platlib="${TEST_PYTHON_PATH}" \
	    || die "cannot install mod_python lib to ${TEST_PYTHON_PATH}"

	python "${TEST_SERVER_ROOT}/test.py" || die "test failed"
}

src_install() {
	emake DESTDIR=${D} install || die

	dohtml -r doc-html/*

	insinto /usr/share/doc/${PF}/examples
	doins examples/*

	apache-module_src_install
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/mod_python
	apache-module_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup
}
