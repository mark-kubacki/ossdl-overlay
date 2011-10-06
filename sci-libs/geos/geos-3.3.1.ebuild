# Copyright 1999-2009 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

EAPI=2
inherit eutils flag-o-matic

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://geos.refractions.net"
SRC_URI="http://download.osgeo.org/geos/${PN}-${PV/_/}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc python ruby"

RDEPEND="ruby? ( virtual/ruby )
	python? ( virtual/python )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	ruby?  ( dev-lang/swig )
	python? ( dev-lang/swig )"

S="${WORKDIR}/${PN}-${PV/_/}"

src_prepare() {
	sed -i \
		-e 's:\/lib\/python:$libdir\/python:g' \
		-e 's:.get_python_lib(0:.get_python_lib(1:g' \
		-e 's:"$base_python_path/":"$base_python_path/lib*/":g' \
		configure || die
}

src_configure() {
	filter-flags -combine -fwhole-program -fwhopr
	econf $(use_enable python) $(use_enable ruby)
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd "${S}/doc"
		emake doxygen-html || die "doc generation failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
	if use doc; then
		cd "${S}/doc"
		dohtml -r doxygen_docs/html/* || die
	fi
}
