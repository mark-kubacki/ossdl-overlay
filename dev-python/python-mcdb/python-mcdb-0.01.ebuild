# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils eutils

DESCRIPTION="A Python extension module for MCDB"
HOMEPAGE="https://github.com/gstrauss/mcdb/tree/master/contrib/python-mcdb"
SRC_URI="http://binhost.ossdl.de/distfiles/mcdb-2012-05-06.tar.xz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

DEPEND="=dev-db/mcdb-0.0.20120506*"
RDEPEND="${DEPEND}"

DOCS="README sample.py"
S="${WORKDIR}/mcdb/contrib/${PN}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/python-mcdb-0.01_systemlib.patch
}
