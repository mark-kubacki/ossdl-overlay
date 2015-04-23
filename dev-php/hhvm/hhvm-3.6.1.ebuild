# Copyright 2014–2015 W. Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"

inherit eutils flag-o-matic git-2 user versionator

DESCRIPTION="Virtual machine designed for executing programs written in Hack and PHP."
HOMEPAGE="http://hhvm.com/"
SRC_URI=""

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 -x86 -arm"

EGIT_REPO_URI="git://github.com/facebook/hhvm.git"
EGIT_BRANCH="HHVM-$(get_version_component_range 1-2 )"
EGIT_COMMIT="HHVM-${PV}"

IUSE="cotire debug devel +freetype gmp hack iconv imagemagick +jemalloc +jpeg jsonc +png sqlite3 +webp xen yaml +zend-compat"

DEPEND="
	>=dev-libs/libevent-2.0.9
	>=dev-libs/libzip-0.11.0
	>=dev-libs/oniguruma-5.9.5
	|| ( >=dev-db/mariadb-10.0 virtual/mysql )
	freetype? ( media-libs/freetype )
	gmp? ( dev-libs/gmp )
	hack? ( >=dev-lang/ocaml-3.12[ocamlopt] )
	iconv? ( virtual/libiconv )
	imagemagick? ( media-gfx/imagemagick )
	jemalloc? ( >=dev-libs/jemalloc-3.5.1[stats,no-prefix] )
	jsonc? ( dev-libs/json-c )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	sqlite3? ( =dev-db/sqlite-3.7* )
	webp? ( media-libs/libvpx )
	yaml? ( dev-libs/libyaml )
	dev-cpp/glog
	dev-cpp/tbb
	dev-libs/elfutils
	dev-libs/expat
	dev-libs/icu
	dev-libs/libdwarf
	dev-libs/libmcrypt
	dev-libs/libmemcached
	>=dev-libs/libpcre-8.35[jit]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/openssl
	net-libs/c-client[kerberos]
	>=net-misc/curl-7.28.0
	net-nds/openldap
	sys-libs/libcap
	sys-libs/ncurses
	sys-libs/zlib
	"
RDEPEND="${DEPEND}
	sys-process/lsof
	"
DEPEND="${DEPEND}
	>=dev-libs/boost-1.49[static-libs]
	dev-libs/cloog[static-libs]
	>=dev-util/cmake-3.0.2
	media-libs/gd[jpeg,png,static-libs]
	>=sys-devel/gcc-4.8[cxx(+),-hardened]
	sys-devel/binutils[static-libs]
	sys-devel/bison
	sys-devel/flex
	sys-libs/readline[static-libs]
	sys-libs/zlib[static-libs]
	"

# for DEPEND run:
# for LIB in $(ldd $(which hhvm) | cut -d ' ' -f 3 | grep -F / | sort -u); do q belongs "${LIB}" | cut -d ' ' -f 1; done | sort -u

pkg_setup() {
	ebegin "Creating hhvm user and group"
	enewgroup hhvm
	enewuser hhvm -1 -1 "/var/lib/hhvm" hhvm
	eend $?
}

src_prepare() {
	git submodule update --init --recursive

	filter-flags -ffast-math
	replace-flags -Ofast -O2 # or compilation will fail

	# output is not humanly readable without this:
	if [[ $(gcc-major-version) -gt 4 ]] || \
	( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -ge 9 ]] ); then
		append-flags -fdiagnostics-color=always
	fi
	# GCC 5.0 with CXX will complain about too few registers without this
	if [[ $(gcc-major-version) -eq 5 && $(gcc-minor-version) -eq 0 ]]; then
		replace-flags -O[3-6] -O2
	fi

	# HHVM's dependencies need this when statically compiled, which is desirable
	append-flags -pthread

	# PR#4342, dependencies already guarantee that PCRE works
	sed -i \
		-e 's:find_package(PCRE REQUIRED):find_package(PCRE):' \
		CMake/HPHPFindLibs.cmake
	# use the already installed PCRE
	sed -i \
		-e '/^  pcre/d' \
		third-party/CMakeLists.txt
	rm -rf third-party/pcre

	epatch_user
}

src_configure() {
	econf \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_INSTALL_DO_STRIP=OFF \
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release) \
		-DSTATIC_CXX_LIB=ON \
		-DBoost_USE_STATIC_LIBS=ON \
		-DCMAKE_EXE_LINKER_FLAGS=-static \
		-DENABLE_ZEND_COMPAT=$(usex zend-compat ON OFF) \
		$(use cotire && printf -- "-DENABLE_COTIRE=ON") \
		$(use jsonc && printf -- "-DUSE_JSONC=ON") \
		$(use xen && printf -- "-DDISABLE_HARDWARE_COUNTERS=ON") \
		${EXTRA_ECONF} || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install

	if use hack; then
		dobin hphp/hack/bin/hh_client
		dobin hphp/hack/bin/hh_server
		dobin hphp/hack/bin/hh_single_type_check
		dodir "/usr/share/hhvm/hack"
		cp -a "${S}/hphp/hack/tools" "${D}/usr/share/hhvm/hack/"
	fi

	if use devel; then
		cp -a "${S}/hphp/test" "${D}/usr/lib/hhvm/"
	fi

	newinitd "${FILESDIR}"/hhvm.initd-r4 hhvm
	newconfd "${FILESDIR}"/hhvm.confd-r4 hhvm

	dodir "/etc/hhvm"
	insinto /etc/hhvm
	newins "${FILESDIR}"/php.ini php.ini
	newins "${FILESDIR}"/php.ini php.ini.dist
	newins "${FILESDIR}"/server.ini server.ini
	newins "${FILESDIR}"/server.ini server.ini.dist

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/hhvm.logrotate hhvm
}
