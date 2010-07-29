# Copyright 2006-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

S=${WORKDIR}
DESCRIPTION="Converter for german text to phonetics to use with mbrola and the script sag_was to make your computer speak"
SRC_URI="http://storage.sk.uni-bonn.de/txt2pho/txt2pho.zip"
HOMEPAGE="http://www.sk.uni-bonn.de/forschung/phonetik/sprachsynthese/txt2pho"
RESTRICT="primaryuri"

RDEPEND="
	app-accessibility/mbrola-de
	app-text/numfilt
	"
DEPEND="sys-devel/gcc"

IUSE=""

SLOT="0"
LICENSE="TXT2PHO"
KEYWORDS="x86"

src_compile (){
	cd ${WORKDIR}/txt2pho
	g++ pipefilt/pipefilt.cc -o pipefilt/pipefilt
	mkdir ${WORKDIR}/etc-temp
        sed 's,/home/tpo/txt2pho/data/,/usr/lib/txt2pho/,' txt2phorc > ${WORKDIR}/etc-temp/txt2pho
	cd ${WORKDIR}/txt2pho/preproc
	make
}

src_install () {
        dobin txt2pho/txt2pho
        dobin txt2pho/pipefilt/pipefilt
        dobin txt2pho/preproc/preproc
        insinto /usr/lib/preproc
        doins txt2pho/preproc/Rules.lst
        doins txt2pho/preproc/Hadifix.abk
        doins txt2pho/preproc/MANUAL
        dodoc txt2pho/README
        insinto /usr/lib/txt2pho
        doins txt2pho/data/*
        insinto /etc
        doins ${WORKDIR}/etc-temp/txt2pho
        dobin ${FILESDIR}/sag_was
        einfo ""
        einfo "You can add your own abbreviations at /usr/lib/preproc/Hadifix.abk"
        einfo ""
}


