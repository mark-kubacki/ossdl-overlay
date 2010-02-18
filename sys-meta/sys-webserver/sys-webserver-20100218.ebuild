# Copyright 2006-2009 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 arm sparc x86"
IUSE=""

RDEPEND="
	sys-meta/sys-base
	>=www-servers/nginx-0.8.33
	dev-util/git
	>=dev-util/subversion-1.6.3
	dev-db/redis
	dev-db/tokyocabinet
	>=net-misc/spread-1.4.0
	"
