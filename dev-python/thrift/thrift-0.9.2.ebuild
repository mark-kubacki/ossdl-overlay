# Copyright 2011-2014 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils distutils-r1

DESCRIPTION="Python bindings for the Apache Thrift RPC system"
HOMEPAGE="http://thrift.apache.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz -> python-${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="amd64 ~x86 ~arm arm64"
IUSE=""
SLOT="0"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	!dev-libs/thrift[python]
	"
