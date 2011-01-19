# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.7"

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

DEPEND=">=dev-lang/python-2.6
	>=dev-libs/glib-2.20"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="gstringc"

S="${WORKDIR}/${MY_P}"
