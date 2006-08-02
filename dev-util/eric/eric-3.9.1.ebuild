# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eric/eric-3.9.1.ebuild,v 1.1 2006/04/23 17:08:30 alex Exp $

inherit python eutils

MY_PV=${PV/"?.?_pre"/"snapshot-"}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="eric3 is a full featured Python IDE that is written in PyQt using the QScintilla editor widget"
HOMEPAGE="http://www.die-offenbachs.de/detlev/eric3.html"
SRC_URI="mirror://sourceforge/eric-ide/${P}.tar.gz
	linguas_de? ( mirror://sourceforge/eric-ide/${PN}-i18n-de-${PV}.tar.gz )
	linguas_fr? ( mirror://sourceforge/eric-ide/${PN}-i18n-fr-${PV}.tar.gz )
	linguas_ru? ( mirror://sourceforge/eric-ide/${PN}-i18n-ru-${PV}.tar.gz )"
#SRC_URI="http://www.die-offenbachs.de/detlev/snapshots/${PN}-${MY_PV}.tar.gz
#	linguas_de? ( http://www.die-offenbachs.de/detlev/snapshots/${PN}-i18n-de-${MY_PV}.tar.gz )
#	linguas_fr? ( http://www.die-offenbachs.de/detlev/snapshots/${PN}-i18n-fr-${MY_PV}.tar.gz )
#	linguas_ru? ( http://www.die-offenbachs.de/detlev/snapshots/${PN}-i18n-ru-${MY_PV}.tar.gz )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="idl"

DEPEND=">=dev-python/PyQt-3.13
	>=dev-python/pyxml-0.8.4"

RDEPEND=">=dev-python/PyQt-3.13
	>=dev-python/pyxml-0.8.4
	idl? ( !sparc? ( >=net-misc/omniORB-4.0.3 ) )"

LANGS="de fr ru"

python_version

src_install() {
	python install.py \
		-b ${ROOT}usr/bin \
		-i ${D} \
		-d "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages" \
		-c

	dodoc HISTORY LICENSE.GPL THANKS eric/README*
	make_desktop_entry "eric3 --nosplash" \
			eric3 \
			"${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/eric3/icons/default/eric.png" \
			"Development;IDE;Qt"
}

pkg_postinst() {
	echo ""
	einfo "If you want to use eric3 with mod_python, have a look at"
	einfo "\"${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/eric3/patch_modpython.py\"."
	echo ""
}
