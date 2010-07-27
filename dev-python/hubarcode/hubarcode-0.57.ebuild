# Copyright 2008-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

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
		-e 's:56p5:57:g' \
		setup.py || die "sed failed"
}

src_install() {
        distutils_src_install
	cp -r "${S}/qrcode/qrcode_data" "${D}$(python_get_sitedir)/qrcode/" || die "qrcode_date couldn't be copied"
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/qrcode
}