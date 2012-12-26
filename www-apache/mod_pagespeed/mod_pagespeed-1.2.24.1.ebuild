# Copyright 1999-2010 Gentoo Foundation
# Copyright 2012 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit apache-module eutils subversion

DESCRIPTION="Apache module for rewriting web pages to reduce latency and bandwidth"
HOMEPAGE="http://code.google.com/p/modpagespeed"

ESVN_REPO_URI="http://modpagespeed.googlecode.com/svn/tags/${PV}/src/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-util/depot-tools
	>=sys-devel/gcc-4.1.0[cxx]
	>=dev-lang/python-2.6.0[threads]
	dev-util/gperf"
RDEPEND=">=www-servers/apache-2.2.0"

APACHE2_MOD_FILE="${S}/out/Release/${PN}.so"
APACHE2_MOD_CONF="80_${PN//-/_}"
APACHE2_MOD_DEFINE="PAGESPEED"

need_apache2

src_unpack() {
	# all the dirty job in WORKDIR
	cd "${WORKDIR}"
	EGCLIENT=/usr/bin/depot_tools/gclient

	# manually fetch sources in distfiles
	if [[ ! -f .gclient ]]; then
		einfo "gclient config -->"
		${EGCLIENT} config ${ESVN_REPO_URI} || die "gclient: error creating config"
	fi

	# run gclient synchronization
	einfo "gclient sync -->"
	einfo "     repository: ${ESVN_REPO_URI}"
	${EGCLIENT} sync --force || die "gclient: unable to sync"

	# move the sources to the working dir
	rsync -rlpgo --exclude=".svn" --exclude=".glient*" src/ "${S}"
	einfo "   working copy: ${S}"
}

src_compile() {
	GYP_CFLAGS="-Duse_system_apache_dev=1 -Dsystem_include_path_httpd" GYP_CXXFLAGS="-Duse_system_apache_dev=1 -Dsystem_include_path_httpd" emake BUILDTYPE=Release V=1 || die "emake failed"
}

src_install() {
	mv -f out/Release/libmod_pagespeed.so out/Release/${PN}.so
	apache-module_src_install

	keepdir /var/cache/mod_pagespeed /var/cache/mod_pagespeed/files /var/cache/mod_pagespeed/cache
	fowners apache:apache /var/cache/mod_pagespeed /var/cache/mod_pagespeed/files /var/cache/mod_pagespeed/cache
	fperms 0770 /var/cache/mod_pagespeed /var/cache/mod_pagespeed/files /var/cache/mod_pagespeed/cache
}
