# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.6:2.7 3:3.1"

inherit distutils

DESCRIPTION="A Python wrapper for Tokyo Cabinet database by Andy Mikhaylenko"
HOMEPAGE="http://code.google.com/p/tokyo-python/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL"
KEYWORDS="amd64 x86 arm"
IUSE=""
SLOT="0"

RDEPEND="dev-db/tokyocabinet
	app-text/tokyodystopia
	net-misc/tokyotyrant
	"
DEPEND="dev-python/setuptools
	${RDEPEND}"

PYTHON_MODNAME="tokyo"

pkg_postinst() {
	python_mod_optimize ${PYTHON_MODNAME}
}
