# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header:  $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="A LaTeX math expression parser/render in Python"
HOMEPAGE="http://code.google.com/p/mathtex/"
SRC_URI="http://mathtex.googlecode.com/files/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="matplotlib"
SLOT="0"
KEYWORDS=""
IUSE="+cairo"

RDEPEND="dev-python/numpy
	media-libs/libpng:1.2
	media-libs/freetype:2
	cairo? ( dev-python/pycairo[svg] )
	"
DEPEND="${RDEPEND}
	sys-libs/zlib
	dev-python/setuptools"
