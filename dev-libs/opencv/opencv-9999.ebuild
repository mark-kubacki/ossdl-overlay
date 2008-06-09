# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic cvs autotools

DESCRIPTION="The Open Computer Vision Library is a collection of algorithms and
sample code for various computer vision problems. "
HOMEPAGE="http://sourceforge.net/projects/opencvlibrary/"
LICENSE="BSD" 
KEYWORDS="~x86"
SRC_URI=""
SLOT="0"
IUSE="gtk ffmpeg xine debug v4l ieee1394 quicktime python apps swig"
RESTRICT="nomirror"

ECVS_SERVER="opencvlibrary.cvs.sourceforge.net:/cvsroot/opencvlibrary"
ECVS_MODULE="opencv"
ECVS_USER="anonymous"
ECVS_PASS=""

DEPEND="gtk? (>=x11-libs/gtk+-2.0.0)
        png? (media-libs/libpng)
        jpeg? (media-libs/jpeg)
        tiff? (media-libs/tiff)
        ffmpeg? (media-video/ffmpeg)
        ieee1394? (media-libs/libdc1394 sys-libs/libraw1394)
		quicktime? (media-libs/libquicktime)"
		
#ALLOWED_FLAGS="-Wall -fno-rtti -pipe -DNDEBUG -march=i686 -ffast-math"

src_compile() {
    strip-flags
	filter-ldflags -O1 -Wl	
	if use xine && use quicktime;
	then
		eerror "You cannot use xine and quicktime concurrently"
		epause 5
		die
	fi
	
	if use xine && use ffmpeg;
	then
		eerror "You cannot use xine and ffmpeg concurrently"
		epause 5
		die
	fi
    
	cd ${WORKDIR}/${ECVS_MODULE}	
    epatch "${FILESDIR}"/enable-use-flags-20061111.patch	
#	autoreconf || die "autoreconf failed"
#	libtoolize --copy --force
	autoconf
	local myconf
	econf \
		${myconf} \
		$(use_with gtk) \
		$(use_with xine) \
		$(use_with ffmpeg) \
		$(use_with v4l) \
		$(use_with ieee1394) \
		$(use_with python) \
		$(use_with swig) \
		$(use_enable apps) \
		$(use_enable debug) || die "econf failed"
    emake || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/${ECVS_MODULE}
    make install DESTDIR=${D} || die "make install failed"
	dodoc AUTHORS COPYING NEWS TODO THANKS README ChangeLog
}
