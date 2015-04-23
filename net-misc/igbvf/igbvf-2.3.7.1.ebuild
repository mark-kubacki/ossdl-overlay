# Public Domain

EAPI=4

inherit linux-mod multilib toolchain-funcs

DESCRIPTION="IGBVF kernel module driver"
HOMEPAGE="http://sourceforge.net/projects/e1000/files/igbvf%20stable/"
SRC_URI="mirror://sourceforge/project/e1000/igbvf%20stable/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
BUILD_TARGETS="clean install"

MODULE_NAMES="igbvf(drivers/net:${S}/src)"

src_compile() {
	CONFIG_CHECK="!CONFIG_IGBVF"
	cd "${S}/src"
	emake
}

src_install() {
	linux-mod_src_install
	nonfatal doman igbvf.7
}