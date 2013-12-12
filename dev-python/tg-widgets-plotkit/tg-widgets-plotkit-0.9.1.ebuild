# Copyright 2008-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="3"
PYTHON_DEPEND="2:2.4:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=PlotKit
MY_P=${MY_PN}-${PV}w3
PYTHON_MODNAME=plotkit

DESCRIPTION="PlotKit Javascript Chart Plotting packed as TurboGears Widget"
HOMEPAGE="https://pypi.python.org/pypi/PlotKit"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"
IUSE=""

RDEPEND="dev-python/turbogears"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
