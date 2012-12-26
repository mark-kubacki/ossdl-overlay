# Copyright 2012-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

inherit eutils subversion

DESCRIPTION="Tools for working with Chromium development. Needed for projects published by Google"
HOMEPAGE="http://dev.chromium.org/developers/how-tos/depottools"

ESVN_REPO_URI="http://src.chromium.org/svn/trunk/tools/depot_tools"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""
RESTRICT="strip binchecks"

DEPEND="sys-apps/grep
	dev-vcs/subversion
	dev-vcs/git
	>=sys-devel/gcc-4.1.0[cxx]
	>=dev-lang/python-2.6.0[threads]
	dev-util/gperf"

S="${WORKDIR}/depot_tools"

src_install() {
	insinto /usr/bin/${PN/-/_}
	doins -r "${S}"/*

	for F in $(grep -rlF '#!' *); do
		fperms 0755 /usr/bin/${PN/-/_}/${F}
	done

	newenvd "${FILESDIR}"/depot-tools.envd 99depot-tools
}
