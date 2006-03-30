# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Emerge this to obtain packages needed for full featured mailservers."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 sparc x86"
IUSE=""

RDEPEND="
	>=sys-meta/sys-mx-${PV}
	=net-mail/cyrus-imapd-2.2*
	dev-libs/cyrus-sasl
	>=mail-mta/postfix-2.2.5
	"
