# Copyright 2011 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Very fast JSON encoder/decoder for Python"
HOMEPAGE="https://github.com/esnme/ultrajson
	http://www.esn.me/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm"
IUSE=""
SLOT="0"

DEPEND="dev-python/setuptools
	app-arch/unzip
	"
