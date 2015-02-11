# Copyright 2015 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"

inherit flag-o-matic

DESCRIPTION="parallel lossless data compressor based on the lzlib compression library"
HOMEPAGE="https://github.com/Blitznote/signify"
SRC_URI="https://github.com/Blitznote/${PN}/releases/download/${PV}/${P}.tar.bz2"
RESTRICT="primaryuri nostrip"

LICENSE="RPL-1.5"
SLOT="0"
KEYWORDS="amd64"

src_prepare() {
	chmod a+x signify
}

src_compile() {
	"${S}"/signify -Vqp mark.pub -m signify || die
}

src_install() {
	dobin signify
	doman "${FILESDIR}"/signify.1

	insinto /etc/signify
	doins mark.pub
}
