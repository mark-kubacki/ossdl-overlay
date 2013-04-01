# Copyright 2012–2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header:  $

EAPI="4"
PYTHON_DEPEND="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils eutils

DESCRIPTION="Native MonetDB client Python API"
HOMEPAGE="http://www.monetdb.org/"
SRC_URI="http://dev.monetdb.org/downloads/sources/Feb2013-SP1/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
SLOT="0"
KEYWORDS="x86 amd64 arm sparc ppc hppa"
IUSE=""

DEPEND="dev-python/setuptools
	!!dev-python/python-monetdb"
RDEPEND=""
PYTHON_MODNAME="monetdb"

S="${WORKDIR}/python-monetdb-${PV}"