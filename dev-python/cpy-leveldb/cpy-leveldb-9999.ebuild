# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="*-jython 3.*"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="leveldb"

inherit git-2 distutils eutils

DESCRIPTION="Python bindings for Google's LevelDB using Python's C API"
HOMEPAGE="https://github.com/forhappy/cpy-leveldb"
EGIT_REPO_URI="http://github.com/forhappy/cpy-leveldb.git"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE=""

DEPEND="app-arch/snappy
	dev-db/leveldb
	"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r "${S}"/leveldb
	rm -r "${S}"/snappy
	epatch "${FILESDIR}"/${PN}-9999-setup.py_dependencies.patch
	epatch "${FILESDIR}"/${PN}-9999-setup.py_ext-only.patch
}
