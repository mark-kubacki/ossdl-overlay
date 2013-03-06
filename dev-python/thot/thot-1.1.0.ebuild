# Copyright 2010-2013 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.3 2.4 3.*"

inherit distutils eutils

DESCRIPTION="A Python-Powered Static Site Generator"
HOMEPAGE="http://mark.ossdl.de/tags/thot"
SRC_URI="http://binhost.ossdl.de/distfiles/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="RPL-1.5"
SLOT="0"
KEYWORDS="amd64 x86 arm ppc hpa sparc"
IUSE="+latex"

S="${WORKDIR}/${P}"

RDEPEND="dev-python/markdown
	dev-python/docutils
	dev-python/pygments
	>=dev-python/python-dateutil-1.5
	dev-python/pytz
	dev-python/pyyaml
	dev-python/murmur
	|| ( >=dev-python/mako-0.4.0 dev-python/jinja )
	|| ( dev-python/Pyphen dev-python/wordaxe )
	latex? ( virtual/latex-base dev-texlive/texlive-latexextra app-text/dvipng )
	"
DEPEND="${DEPEND}
	dev-python/setuptools
	"
