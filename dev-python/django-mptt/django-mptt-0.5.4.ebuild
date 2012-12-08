# Copyright 2012 Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Utilities for implementing a modified pre-order traversal tree in Django"
HOMEPAGE="https://github.com/django-mptt/django-mptt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86 arm"
IUSE=""

LICENSE="BSD"
SLOT="0"
PYTHON_MODNAME="mptt"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-python/django-1.2
	dev-python/setuptools
	"