# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.5:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* 2.7-pypy-* *-jython"

inherit distutils

MY_PN=python-gstringc
MY_P=${MY_PN}-${PV}

DESCRIPTION="A wrapper written in C for GLib GString."
HOMEPAGE="http://code.google.com/p/python-gstringc/"
SRC_URI="http://python-gstringc.googlecode.com/files/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

RDEPEND=">=dev-libs/glib-2.20"
DEPEND="dev-python/setuptools
	${RDEPEND}"

PYTHON_MODNAME="gstringc"

S="${WORKDIR}/${MY_P}"
