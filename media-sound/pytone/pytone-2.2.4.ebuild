# Copyright 1999-2005 Gentoo Foundation
# Copyright 2008-2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.*"

inherit distutils

MY_PN="PyTone"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="PyTone is a music jukebox written in Python with a curses based GUI."
HOMEPAGE="http://www.luga.de/pytone/"
SRC_URI="http://www.luga.de/pytone/download/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms mad xosd"

RDEPEND="
	mad? (
		dev-python/pyao
		dev-python/pymad
		dev-python/pyvorbis
		)
	xmms? ( dev-python/pyxmms )
	xosd? ( x11-libs/xosd )
	"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_python_version
	echo \#\!/bin/sh > pytone
	echo python /usr/lib/python${PYVER}/site-packages/pytone/pytone.py \"\$@\" \
	>> pytone
	echo \#\!/bin/sh > pytonectl
	echo python /usr/lib/python${PYVER}/site-packages/pytone/pytonectl.py \"\$@\" \
	>> pytonectl
	pytonectl
	distutils_src_install
}
