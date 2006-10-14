# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Emerge this to obtain packages needed for mailexchangers."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 sparc x86"
IUSE=""

RDEPEND="
	>=sys-meta/sys-base-${PV}
	>=mail-mta/postfix-2.2.5
	mail-filter/postgrey
	mail-filter/spamassassin
	mail-filter/dcc
	virtual/perl-Time-HiRes
	>=dev-perl/Mail-SPF-Query-1.998
	dev-perl/Geo-IP
	dev-perl/Net-SSLeay
	mail-filter/dk-milter
	virtual/perl-MIME-Base64
	"
