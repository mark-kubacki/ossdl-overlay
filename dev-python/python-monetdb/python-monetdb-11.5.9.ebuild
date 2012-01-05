# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header:  $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Native MonetDB client Python API"
HOMEPAGE="http://www.monetdb.org/"
SRC_URI="http://dev.monetdb.org/downloads/sources/Aug2011-SP3/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="MonetDBPL-1.1"
SLOT="0"
KEYWORDS="x86 amd64 arm sparc ppc hppa"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
PYTHON_MODNAME="monetdb"
