# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5 3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="simple and lightweight WSGI micro web-framework"
HOMEPAGE="http://bottlepy.org/docs/dev/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
KEYWORDS="amd64 x86 arm"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools
	"
