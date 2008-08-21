# Copyright 2008 OSSDL.de
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

MY_PN="PyQrCodec"
MY_P="${MY_PN}"

DESCRIPTION="PyQrCodec is a Python module for encoding and decoding QrCode images."
HOMEPAGE="http://www.pedemonte.eu/pyqr/"
SRC_URI="http://www.pedemonte.eu/pyqr/files/PyQrcodec_Linux.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"
IUSE=""
SLOT="0"

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}
	dev-libs/opencv
	dev-python/imaging"

PYTHON_MODNAME=$MY_PN
S="${WORKDIR}/${MY_PN}"
