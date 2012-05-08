# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

MY_PN="LuxiMono"
DESCRIPTION="LaTeX Type1 typewriter font"
# SRC_URI="http://dev.gentooexperimental.org/~dreeevil/${MY_PN}-${PV}.zip"
SRC_URI="ftp://tug.ctan.org/pub/tex-archive/fonts/${MY_PN}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/fonts/LuxiMono/"
LICENSE="luximono"

IUSE=""
SLOT="0"
KEYWORDS="amd64 x86 arm"

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}
SUPPLIER="public"

src_unpack(){
	unpack ${A}
	cd "${S}"
	unzip ul9.zip || die "unzip failed"
}

src_install() {
	local pack="luxi"
	local texshr="${TEXMF}/fonts"

	# latex-package_src_doinstall generally uses different
	# directories than this package expects

	dodoc doc/fonts/luxi/* README.luximono || die "dodoc failed"

	insinto ${texshr}/map/dvips/luxi
	doins dvips/config/* || die

	insinto ${texshr}/afm/${SUPPLIER}/luxi
	doins *.afm || die "doins afm failed"

	insinto ${texshr}/tfm/${SUPPLIER}/luxi
	doins fonts/tfm/public/luxi/*.tfm || die "doins tfm failed"

	insinto ${texshr}/vf/${SUPPLIER}/luxi
	doins fonts/vf/public/luxi/*.vf || die "doins vf failed"

	insinto ${texshr}/type1/${SUPPLIER}/luxi
	doins *.pfb || die "doins pfb failed"

	insinto ${TEXMF}/tex/latex/luxi
	doins tex/latex/luxi/* || die

}

pkg_postinst() {
#	this order is intended
	latex-package_rehash
	updmap-sys --enable Map ul9.map
}

pkg_postrm() {
	updmap-sys --disable ul9.map
	latex-package_rehash
}
