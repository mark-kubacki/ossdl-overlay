# Copyright 2008-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 3.*"

inherit distutils eutils

MY_PN="huBarcode"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="generation of barcodes in Python"
HOMEPAGE="https://github.com/hudora/huBarcode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	http://binhost.ossdl.de/distfiles/hubarcode_qrcode_data.tar.xz"

LICENSE="BSD"
KEYWORDS="x86 amd64 arm ~ia64 ~ppc ~sparc"
IUSE=""
SLOT="0"

RDEPEND="dev-python/imaging"
DEPEND="dev-python/setuptools
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i \
		-e '/use_setuptools/d' \
		-e '/install_requires=\[.*\],/d' \
		-e 's:56p5:57:g' \
		setup.py || die "sed failed"
}

src_install() {
        distutils_src_install
	install_qrcode_data() {
		insinto "$(python_get_sitedir)/hubarcode/qrcode/"
		doins -r "${WORKDIR}/qrcode_data" || die "qrcode_data couldn't be copied"
	}
	python_execute_function -q install_qrcode_data
}
