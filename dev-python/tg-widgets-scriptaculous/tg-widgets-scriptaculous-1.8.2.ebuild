# Copyright 2008-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=Scriptaculous
MY_P=${MY_PN}-${PV}
PYTHON_MODNAME=${MY_PN}

DESCRIPTION="TurboGears widget wrapper for the Scriptaculous JavaScript library"
HOMEPAGE="https://pypi.python.org/pypi/Scriptaculous"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"
IUSE=""

RDEPEND="dev-python/turbogears"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
