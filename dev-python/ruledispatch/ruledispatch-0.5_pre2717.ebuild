# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit distutils-r1 eutils versionator flag-o-matic

MY_PN="RuleDispatch"
MY_P="${MY_PN}-$(get_version_component_range 1-2)a1.dev-$(get_version_component_range 3-)"
MY_P="${MY_P/pre/r}"

DESCRIPTION="Rule-based Dispatching and Generic Functions"
HOMEPAGE="http://peak.telecommunity.com/"
SRC_URI="http://peak.telecommunity.com/snapshots/${MY_P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="|| ( PSF-2.4 ZPL )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/pyprotocols-1.0_pre2306[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_test() {
	cd "${BUILD_DIR}/lib" || die
	# parallel build makes a salad; einfo msg lets us see what's occuring
	for test in dispatch/tests/test_*.py; do
		"${PYTHON}" $test && einfo "Tests $test passed under ${EPYTHON}" \
		|| die "Tests failed under ${EPYTHON}"
	done
	# doctest appears old and unmaintained, left for just in case
	# "${PYTHON}" dispatch/tests/doctest.py
	einfo "Tests passed under ${EPYTHON}"
}
