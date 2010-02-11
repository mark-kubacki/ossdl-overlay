# Copyright 2008-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils eutils

MY_PN="huBarcode"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="generation of barcodes in Python"
HOMEPAGE="https://cybernetics.hudora.biz/projects/wiki/huBarcode"
SRC_URI="http://binhost.ossdl.de/distfiles/${MY_P}.tar.lzma"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="x86 amd64 arm ~ia64 ~ppc ~sparc"
IUSE=""
SLOT="0"

RDEPEND="dev-python/imaging"
DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )
	dev-python/setuptools
	${RDEPEND}"

PYTHON_MODNAME=$MY_PN
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i \
		-e '/use_setuptools/d' \
		-e '/install_requires=\[.*\],/d' \
		setup.py || die "sed failed"
}

src_install() {
        distutils_src_install
        distutils_python_version

	cp -r "${S}/qrcode/qrcode_data" "${D}/usr/$(get_libdir)/python${PYVER}/site-packages/${MY_PN}/qrcode/"
}