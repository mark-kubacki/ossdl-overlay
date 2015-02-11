# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit versionator java-vm-2 eutils pax-utils

DESCRIPTION="Open Source Messaging"
HOMEPAGE="http://activemq.apache.org"
SRC_URI="mirror://apache/activemq/${PV}/${P}-bin.tar.gz"

SLOT="0"
LICENSE="apache-2"
KEYWORDS="amd64 x86"
RESTRICT="strip primaryuri"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND="${RDEPEND}"

src_unpack() {
	local modules

	unpack ${A}
}

src_install() {
	newinitd ${FILESDIR}/activemq.rc activemq
	newconfd ${FILESDIR}/activemq.confd activemq

	dodir /opt/${PN}

	cp -pPR * "${D}/opt/${PN}"/ || die "failed to copy"
}

pkg_preinst() {
	if [[ -z "$(egetent passwd activemq)" ]]; then
		einfo "Adding activemq user and group"
		enewgroup activemq
		enewuser  activemq -1 -1 /opt/${PN} activemq
	fi

	chown -R root:activemq  ${D}/opt/${PN}
	chown -R activemq:activemq  ${D}/opt/${PN}/data
	chmod -R u=rwX,g=rX,o= ${D}/opt/${PN}
}

