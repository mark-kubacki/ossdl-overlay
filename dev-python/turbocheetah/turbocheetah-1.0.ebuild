# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/turbocheetah/turbocheetah-0.9.5.ebuild,v 1.3 2007/07/11 06:19:47 mr_bones_ Exp $

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="~amd64 ~x86"

MY_PN=TurboCheetah
MY_P=${MY_PN}-${PV}

DESCRIPTION="TurboGears plugin to support use of Cheetah templates."
HOMEPAGE="http://docs.turbogears.org/1.0/CheetahTemplating"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/cheetah-1.0"
DEPEND="${RDEPEND}
	test? ( dev-python/nose )
	dev-python/setuptools"

S=${WORKDIR}/${MY_P}

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}
