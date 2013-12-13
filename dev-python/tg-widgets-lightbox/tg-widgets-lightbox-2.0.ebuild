# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="TurboGears widget wrapper for the Lightbox JavaScript library"
HOMEPAGE="http://www.turbogears.org/widgets/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="dev-python/turbogears
	dev-python/tg-widgets-scriptaculous"
DEPEND="${RDEPEND}"

PYTHON_MODNAME="lightbox"
