# Copyright 2011 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Very fast JSON encoder/decoder for Python"
HOMEPAGE="http://pypi.python.org/pypi/python-cjson/
	http://ag-projects.com/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2"
KEYWORDS="amd64 x86 arm"
IUSE="+test"
SLOT="0"

DEPEND="dev-python/setuptools
	"

src_prepare() {
	# fix for bug reported at http://garybernhardt.blogspot.com/2007/07/when-json-isnt-json.html
	# >>> cjson.decode(simplejson.dumps('/'))
	# '/'
	epatch "${FILESDIR}/python-cjson-1.0.5.diff"
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" jsontest.py
	}
	python_execute_function testing
}
