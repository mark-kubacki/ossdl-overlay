# Copyright 2007 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License
# $Header: $

inherit eutils

IUSE="spf rbl curl geoip"

DESCRIPTION="A greylisting and SPF milter"
HOMEPAGE="http://hcpnet.free.fr/milter-greylist/"
SRC_URI="ftp://ftp.espci.fr/pub/milter-greylist/${P}.tgz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~sparc_fbsd ~x86 ~x86_fbsd"

DEPEND=">=sys-devel/autoconf-2.57
	>=sys-devel/automake-1.7.2"
RDEPEND=" || ( mail-filter/libmilter >=mail-mta/sendmail-8.12 )
	spf? ( >=mail-filter/libspf2-1.2.5 )
	rbl? ( >=net-dns/bind-9.0.0 )
	curl? ( net-misc/curl )
	geoip? ( dev-libs/geoip )
	"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/milter milter
}

src_compile() {
	local myconf
	myconf="--with-user=milter"
	myconf="${myconf} --with-dumpfile=/var/milter/greylist_dump.db"
	myconf="${myconf} $(use_with spf libspf2)"
	myconf="${myconf} $(use_with curl)"
	myconf="${myconf} $(use_with geoip libGeoIP)"
	if use rbl; then
		myconf="${myconf} --with-libbind --enable-dnsrbl"
	fi
	if has_version >=mail-mta/postfix-2.4.0; then
		myconf="${myconf} --with-postfix"
	fi

	econf ${myconf} && emake
}

src_install() {
	insinto /etc/mail
	doins greylist.conf
	newinitd "${FILESDIR}/milter-greylist.rc" milter-greylist
	newconfd "${FILESDIR}/milter-greylist.confd" milter-greylist

	dodir /var/run/milter
	keepdir /var/run/milter
	fowners milter:milter /var/run/milter
	dodir /var/milter
	keepdir /var/milter
	fowners milter:milter /var/milter

	dosbin milter-greylist
	doman *.5 *.8
	dodoc README ChangeLog
}
