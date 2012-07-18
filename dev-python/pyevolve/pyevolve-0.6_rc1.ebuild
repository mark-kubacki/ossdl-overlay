# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.5:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

MY_PN="Pyevolve"
MY_PV=${PV/_/}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="complete genetic algorithm framework written in pure python"
HOMEPAGE="http://pyevolve.sourceforge.net/"
SRC_URI="http://pyevolve.sourceforge.net/distribution/${MY_PV/./_}/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="PSF"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE=""

RDEPEND=">=dev-python/matplotlib-0.98.4
	>=media-gfx/pydot-1.0.2
	"
DEPEND="dev-python/setuptools"

S="${WORKDIR}/${MY_P}"
