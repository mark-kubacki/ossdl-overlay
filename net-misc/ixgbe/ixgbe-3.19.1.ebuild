# Public Domain

EAPI=4

inherit linux-mod multilib toolchain-funcs

DESCRIPTION="IXGBE kernel module driver"
HOMEPAGE="http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=14687&lang=eng&wapkw=ixgbe"
SRC_URI="mirror://sourceforge/project/e1000/ixgbe%20stable/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
BUILD_TARGETS="clean install"

MODULE_NAMES="ixgbe(drivers/net:${S}/src)"

src_compile() {
	CONFIG_CHECK="!CONFIG_IXGBE"
	cd "${S}/src"
	emake
}

src_install() {
	linux-mod_src_install
	doman ixgbe.7
}