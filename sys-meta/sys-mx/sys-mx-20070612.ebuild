# Copyright 2006-2007 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Emerge this to obtain packages needed for mailexchangers."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

RDEPEND="
	sys-meta/sys-base
	>=mail-mta/postfix-2.4.0
	mail-filter/milter-greylist
	mail-filter/spamassassin
	mail-filter/dcc
	net-dns/bind
	virtual/perl-Time-HiRes
	dev-perl/Geo-IP
	dev-perl/Net-SSLeay
	mail-filter/dk-milter
	virtual/perl-MIME-Base64
	"
