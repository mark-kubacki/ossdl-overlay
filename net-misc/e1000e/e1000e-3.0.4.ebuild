# Public Domain

EAPI=4

inherit linux-mod multilib toolchain-funcs

DESCRIPTION="e1000e Intel NIC kernel module driver"
HOMEPAGE="https://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=15817&lang=eng&wapkw=e1000e"
SRC_URI="mirror://sourceforge/project/e1000/e1000e%20stable/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
BUILD_TARGETS="clean install"

MODULE_NAMES="e1000e(drivers/net:${S}/src)"

src_compile() {
	CONFIG_CHECK="!CONFIG_E1000E"
	cd "${S}/src"
	emake
}

src_install() {
	linux-mod_src_install
	nonfatal doman e1000e.7
}
