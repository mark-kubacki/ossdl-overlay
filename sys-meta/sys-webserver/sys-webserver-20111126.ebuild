# Copyright 2006-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"
RESTRICT="bindist"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 arm sparc x86"
IUSE="cgi"

RDEPEND="
	sys-meta/sys-base
	>=www-servers/nginx-0.8.33
	cgi? (
		www-servers/spawn-fcgi
		www-misc/fcgiwrap
	)
	dev-vcs/git
	dev-vcs/tig
	>=dev-vcs/subversion-1.6.3
	dev-db/redis
	dev-db/tokyocabinet
	>=net-misc/spread-1.4.0
	"
