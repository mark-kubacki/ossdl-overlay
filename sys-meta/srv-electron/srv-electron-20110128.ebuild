# Copyright 2006-2011 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="SheevaPlug server."
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86 arm"
IUSE="pyzhon webserver multimedia"

RDEPEND="
	app-arch/cfv
	app-misc/colordiff
	dev-db/redis
	dev-embedded/u-boot-tools
	net-fs/nfs-utils
	net-libs/zeromq
	dev-util/ccache
	>=net-dns/pdns-recursor-3.3
	net-misc/s3cmd
	net-misc/udhcp
	net-misc/wol
	sys-devel/distcc
	sys-process/lsof
	www-client/links
	dev-vcs/git
	dev-vcs/gitosis-gentoo
	webserver? (
		sys-meta/sys-webserver
		app-text/dos2unix
		www-apps/trac
	)
	python? (
		dev-libs/boost[python]
		dev-libs/protobuf
		dev-python/dnspython
		dev-python/feedparser
		dev-python/imaging
		dev-python/ipython
		dev-python/matplotlib
		dev-python/mechanize
		dev-python/redis-py
		dev-python/setuptools
		dev-python/soappy
	)
	multimedia? (
		media-gfx/dcraw
		media-gfx/exif
		media-gfx/imagemagick
		media-libs/exiftool
		media-sound/streamripper
		media-video/ffmpeg
	)
	"
