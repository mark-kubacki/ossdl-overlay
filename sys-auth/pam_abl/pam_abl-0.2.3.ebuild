# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The pam_abl module monitors failed authentication attempts and automatically blacklists those hosts (and accounts) that are responsible for large numbers of failed attempts."
HOMEPAGE="http://www.hexten.net/pam_abl/"
S=${WORKDIR}/${PN}

SRC_URI="mirror://sourceforge/pam-abl/${P}.tar.gz"
RDEPEND=">=sys-libs/pam-0.72 
	sys-libs/db
	"
LICENSE="as-is"
SLOT="0"
KEYWORDS="*~ ~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
        unpack ${A}
}

src_compile() {
	emake
}

src_install() {
	dosbin tools/${PN}
	exeinto /lib/security
	doexe ${PN}.so

	# directory 'doc' is already to be found on ${HOMEPAGE}.
	dodoc THANKS NEWS AUTHORS conf/pam_abl.conf conf/system-auth

	einfo "On copying the sample configuration file..."
	insinto /etc/security
	doins conf/pam_abl.conf
	einfo "Please remember to edit /etc/security/pam_ablc.conf."
}
