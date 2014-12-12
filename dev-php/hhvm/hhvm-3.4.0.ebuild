# Copyright 2014 W. Mark Kubacki, Vadim Borodavko
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"
CMAKE_MIN_VERSION="2.8.5"

inherit cmake-utils git-2 user versionator

DESCRIPTION="Virtual machine designed for executing programs written in Hack and PHP."
HOMEPAGE="http://hhvm.com/"
SRC_URI=""

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64 ~x86 -arm64"

EGIT_REPO_URI="git://github.com/facebook/hhvm.git"
EGIT_BRANCH="HHVM-$(get_version_component_range 1-2 )"
EGIT_COMMIT="HHVM-${PV}"

IUSE="cotire debug devel +freetype gmp hack iconv imagemagick +jemalloc +jpeg jsonc +png sqlite +webp xen yaml +zend-compat"

DEPEND=">=dev-libs/boost-1.49[static-libs]
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
	sqlite? ( >=dev-db/sqlite-3.8.0 )
	webp? ( media-libs/libvpx )
	yaml? ( dev-libs/libyaml )
	dev-cpp/glog
	dev-cpp/tbb
	dev-libs/cloog
	dev-libs/elfutils
	dev-libs/expat
	dev-libs/icu
	dev-libs/libdwarf
	dev-libs/libmcrypt
	dev-libs/libmemcached
	dev-libs/libpcre[jit]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/openssl
	media-libs/gd[jpeg,png]
	net-libs/c-client[kerberos]
	>=net-misc/curl-7.28.0
	net-nds/openldap
	sys-libs/libcap
	sys-libs/ncurses
	sys-libs/readline
	sys-libs/zlib
	"
RDEPEND="${DEPEND}
	sys-process/lsof
	"
DEPEND="${DEPEND}
	>=sys-devel/gcc-4.8[-hardened]
	sys-devel/binutils[static-libs]
	sys-devel/bison
	sys-devel/flex
	"

pkg_setup() {
	ebegin "Creating hhvm user and group"
	enewgroup hhvm
	enewuser hhvm -1 -1 "/var/lib/hhvm" hhvm
	eend $?
}

src_prepare() {
	git submodule update --init --recursive

	epatch_user
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DBoost_USE_STATIC_LIBS=ON
		-DCMAKE_EXE_LINKER_FLAGS=-static
		$(cmake-utils_use_enable zend-compat ZEND_COMPAT)
		$(cmake-utils_use_enable cotire COTIRE)
		$(cmake-utils_use_use jsonc JSONC)
		$(cmake-utils_use_disable xen HARDWARE_COUNTERS)
		${EXTRA_ECONF}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

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
