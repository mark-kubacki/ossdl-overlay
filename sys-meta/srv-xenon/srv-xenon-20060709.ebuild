# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Basic applications for any LAMPP configuration."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE=""

# Subversion 1.3* has problems with SWIG bindings
# Apache 2.2* crashes with MySQL support build in APR-Util

RDEPEND="
	sys-meta/sys-webserver
	sys-meta/sys-mailserver
	sys-fs/jfsutils
	www-apps/trac
	sys-fs/quota
	sys-fs/quotatool
	dev-php/adodb
	dev-php5/adodb-ext
	dev-python/mysql-python
	app-editors/vim
	media-gfx/imagemagick
	media-sound/streamripper
	media-video/ffmpeg
	app-dicts/aspell-de
	app-dicts/aspell-en
	"
