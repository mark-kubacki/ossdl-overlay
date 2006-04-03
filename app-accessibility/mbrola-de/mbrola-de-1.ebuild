# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

VOICENO=6

S=${WORKDIR}

URL="http://tcts.fpms.ac.be/synthesis/mbrola"

DESCRIPTION="de1 to de${VOICENO} mbrola voice libraries for Festival TTS"
SRC_URI="${URL}/dba/de1/de1-980227.zip
	 ${URL}/dba/de2/de2-990106.zip
	 ${URL}/dba/de3/de3-000307.zip
	 ${URL}/dba/de4/de4.zip
	 ${URL}/dba/de5/de5.zip
	 ${URL}/dba/de6/de6.zip
	 ${URL}/dba/de7/de7.zip
	 ${URL}/dba/de8/de8.zip"
RESTRICT="nomirror"

DEPEND=">=app-accessibility/festival-1.4.2
	>=app-accessibility/mbrola-3
	app-arch/unzip
	amd64? ( app-emulation/emul-linux-x86-glibc )"

SLOT="0"
LICENSE="MBROLA"
KEYWORDS="~x86"

src_compile() {
	einfo "Only installing voices."
}

src_install () {
	FESTLIB=/usr/lib/festival/voices/german

	local COUNTER=1
	let VOICENO=VOICENO+1
	while [ $COUNTER -lt $VOICENO ]; do
		einfo "installing de${COUNTER}"
		insinto ${FESTLIB}/de${COUNTER}_mbrola/de${COUNTER}
		doins de${COUNTER}/de${COUNTER}
		insinto ${FESTLIB}/de${COUNTER}_mbrola/de${COUNTER}/TEST
		doins de${COUNTER}/TEST/*
		dodoc de${COUNTER}/de${COUNTER}.txt
		let COUNTER=COUNTER+1
	done

}
