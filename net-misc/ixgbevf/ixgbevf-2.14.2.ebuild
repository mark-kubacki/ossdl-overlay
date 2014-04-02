# Public Domain

EAPI=4

inherit linux-mod multilib toolchain-funcs

DESCRIPTION="IXGBEVF kernel module driver"
HOMEPAGE="http://sourceforge.net/projects/e1000/files/ixgbevf%20stable/"
SRC_URI="mirror://sourceforge/project/e1000/ixgbevf%20stable/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
BUILD_TARGETS="clean install"

MODULE_NAMES="ixgbevf(drivers/net:${S}/src)"

src_compile() {
	CONFIG_CHECK="!CONFIG_IXGBEVF"
	cd "${S}/src"
	emake
}

src_install() {
	linux-mod_src_install
	nonfatal doman ixgbevf.7
}