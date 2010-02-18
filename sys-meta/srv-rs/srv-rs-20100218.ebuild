# Copyright 2010 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="RS server."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86 arm"
IUSE=""

RDEPEND="
	app-arch/cfv
	app-misc/colordiff
	dev-util/ccache
	net-misc/s3cmd
	sys-devel/distcc
	sys-process/lsof
	www-client/links
	sys-meta/sys-webserver
	app-text/dos2unix
	dev-python/dnspython
	dev-python/feedparser
	dev-python/imaging
	dev-python/ipython
	dev-python/matplotlib
	dev-python/mechanize
	dev-python/setuptools
	dev-python/anzu
	dev-cpp/asio
	"
