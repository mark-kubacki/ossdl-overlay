# placed in Public Domain

EAPI="5"

inherit linux-mod

DESCRIPTION="Cryptodev-linux module"
HOMEPAGE="http://cryptodev-linux.org/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

DEPEND=""
RDEPEND=""

MODULE_NAMES="cryptodev()"
BUILD_TARGETS="build"

src_install() {
	linux-mod_src_install

	insinto /usr/include/crypto
	doins crypto/cryptodev.h
}
