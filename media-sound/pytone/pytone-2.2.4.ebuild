# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PyTone"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="PyTone is a music jukebox written in Python with a curses based GUI."
HOMEPAGE="http://www.luga.de/pytone/"
SRC_URI="http://www.luga.de/pytone/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms mad xosd"

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
	mad? ( 
		dev-python/pyao
		dev-python/pymad
		dev-python/pyvorbis 
		)
	xmms? ( dev-python/pyxmms)
	xosd? ( x11-libs/xosd )
	"

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
