# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=4

inherit eutils

DESCRIPTION="faster alternative to CDB constant database"
HOMEPAGE="https://github.com/gstrauss/mcdb"
SRC_URI="http://binhost.ossdl.de/distfiles/${PN}-2012-05-06.tar.xz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="
        "
RDEPEND="${DEPEND}
	"

S="${WORKDIR}/${PN}"

src_compile() {
	emake PREFIX=${D} PREFIX_USR=${D}/usr/
}

src_test() {
	make test
}

src_install() {
	emake install PREFIX=${D}/usr/ PREFIX_USR=${D}/usr/
}
