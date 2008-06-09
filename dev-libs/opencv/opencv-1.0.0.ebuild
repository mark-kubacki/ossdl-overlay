# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="The Open Computer Vision Library is a collection of algorithms and
sample code for various computer vision problems." 
HOMEPAGE="http://www.intel.com/research/mrl/research/opencv/index.htm
http://sourceforge.net/projects/opencvlibrary/"
SRC_URI="mirror://sourceforge/${PN}library/${P}.tar.gz"
LICENSE="BSD" 
KEYWORDS="~x86"
SLOT="1"
IUSE="gtk xine ffmpeg ffmpeg ieee1394 v4l debug apps"
RESTRICT="nomirror"

DEPEND="gtk2? (>=x11-libs/gtk+-2.0.0)
	ffmpeg? (media-video/ffmpeg)
	ieee1394? (media-libs/libdc1394 sys-libs/libraw1394)
	xine? (media-libs/xine-lib) "

ALLOWED_FLAGS="-Wall -fno-rtti -pipe -march=i686 -ffast-math \
-fomit-frame-pointer"

src_unpack() {
        unpack ${A}
}

src_compile() {
    strip-flags
	filter-flags -O*
	if use debug; then
		filter-ldflags -O1 -Wl
    	filter-ldflags --enable-new-dtags -Wl
    	filter-ldflags --sort-common -s
    	filter-ldflags -Wl
    	filter-ldflags -O1
	fi

    cd ${S}
	epatch "${FILESDIR}"/enable-use-flags-1.0.0.patch
#	epatch "${FILESDIR}"/cvcap_ffmpeg-1.0.0.patch
	epatch "${FILESDIR}"/cvcap_ffmpeg-img_convert.patch
	autoreconf || die "autoreconf failed"
	libtoolize --copy --force
	autoconf

	if use ieee1394; then
	       myconf="${myconf} --with-1394libs"
	fi

	local myconf
    econf \
		${myconf} \
		$(use_with gtk) \
		$(use_with xine) \
		$(use_with v4l) \
		$(use_enable apps) \
		$(use_enable debug) || die "econf failed"
    emake || die "emake failed"
}

src_install() {
    make install DESTDIR=${D} || die "make install failed"
	dodoc AUTHORS COPYING NEWS TODO
}
