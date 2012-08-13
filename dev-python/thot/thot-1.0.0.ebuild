# Copyright 2010-2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2:2.6:2.7"

inherit distutils eutils

DESCRIPTION="A Python-Powered Static Site Generator"
HOMEPAGE="http://mark.ossdl.de/tags/thot"
SRC_URI="http://github.com/downloads/wmark/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="RPL-1.5"
SLOT="0"
KEYWORDS="amd64 x86 arm ppc hpa sparc"
IUSE="+latex"

GITHUB_NAME="wmark-${PN}-fa7cab4"
S="${WORKDIR}/${GITHUB_NAME}"

RDEPEND="dev-python/markdown
	dev-python/docutils
	dev-python/pygments
	>=dev-python/python-dateutil-1.5
	dev-python/pytz
	dev-python/pyyaml
	dev-python/murmur
	|| ( >=dev-python/mako-0.4.0 dev-python/jinja )
	latex? ( virtual/latex-base app-text/dvipng )
	"
DEPEND="${DEPEND}
	dev-python/setuptools
	"

pkg_postinst() {
	python_mod_optimize thot
}
