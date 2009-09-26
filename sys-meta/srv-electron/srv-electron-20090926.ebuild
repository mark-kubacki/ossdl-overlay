# Copyright 2006-2009 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="SheevaPlug server."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86 arm"
IUSE="turbogears websever mutlimedia"

RDEPEND="
	app-arch/cfv
	app-misc/colordiff
	dev-embedded/u-boot-tools
	dev-util/ccache
	net-misc/s3cmd
	net-misc/udhcp
	net-misc/wol
	sys-devel/distcc
	sys-process/lsof
	www-client/links
	webserver? (
		sys-meta/sys-webserver
		dev-php/adodb
		dev-php5/adodb-ext
		app-text/dos2unix
		www-apps/trac
	)
	turbogears? (
		dev-python/beautifulsoup
		dev-python/dnspython
		dev-python/feedparser
		dev-python/imaging
		dev-python/ipython
		dev-python/matplotlib
		dev-python/mechanize
		dev-python/setuptools
		dev-python/soappy
		dev-python/turbogears
		dev-python/mysql-python
	)
	multimedia? (
		media-gfx/imagemagick
		media-sound/streamripper
		media-video/ffmpeg
	)
	"
