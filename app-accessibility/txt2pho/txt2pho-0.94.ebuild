# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/txt2pho/txt2pho-0.94.ebuild,v 1.5 2004/08/13 21:00:00 murray_b Exp $

S=${WORKDIR}
DESCRIPTION="Converter for german text to phonetics to use with mbrola and the script sag_was to make your computer speak"
SRC_URI="http://www.ikp.uni-bonn.de/dt/forsch/phonetik/hadifix/txt2pho.zip"
HOMEPAGE="http://www.ikp.uni-bonn.de/dt/forsch/phonetik/hadifix/HADIFIXforMBROLA.html"
RESTRICT="nomirror"

DEPEND="app-accessibility/mbrola-de"

IUSE=""

SLOT="0"
LICENSE="TXT2PHO"
KEYWORDS="x86"

src_compile (){
        cd ${WORKDIR}/txt2pho
        mkdir ${WORKDIR}/etc-temp
        sed 's,/home/tpo/txt2pho/data/,/usr/lib/txt2pho/,' txt2phorc > ${WORKDIR}/etc-temp/txt2pho
        tar xvzf numfilt-0.1.tar.gz
        cd numfilt-0.1
        cc -o numfilt numfilt.c
        cd ..
        unzip preproc.zip
        cd preproc
        mkdir obj
        make
}

src_install () {

        dobin txt2pho/txt2pho
        dobin txt2pho/numfilt-0.1/numfilt
        dobin txt2pho/pipefilt
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


