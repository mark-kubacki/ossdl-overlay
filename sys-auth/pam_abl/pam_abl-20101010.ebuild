# Copyright 2007 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="The pam_abl module monitors failed authentication attempts and automatically blacklists those hosts (and accounts) that are responsible for large numbers of failed attempts."
HOMEPAGE="http://www.hexten.net/pam_abl/"
S=${WORKDIR}/pam-abl
ESVN_REPO_URI="https://pam-abl.svn.sourceforge.net/svnroot/pam-abl"

RDEPEND=">=sys-libs/pam-0.72
	sys-libs/db
	"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	einfo "Running autoreconf"
	autoreconf -i -s . || die "autoreconf failed"
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dosbin tools/${PN}
	exeinto /lib/security
	doexe .libs/${PN}.so

	dodoc THANKS NEWS AUTHORS conf/pam_abl.conf conf/system-auth
        dohtml doc/*.html doc/*.css

        dodir /var/lib/abl
        keepdir /var/lib/abl
	einfo "On copying the sample configuration file..."
	insinto /etc/security
	doins conf/pam_abl.conf
	einfo "Please remember to edit /etc/security/pam_abl.conf."
}
