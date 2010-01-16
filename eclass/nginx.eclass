# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Original Author: W-Mark Kubacki <wmark@hurrikane.de>
# Purpose: Collects common Nginx specific ebuild functions along with helper
#          functions.

EAPI="2"

inherit eutils ssl-cert toolchain-funcs

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.net/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz
	nginx_modules_redis? ( http://people.freebsd.org/~osa/ngx_http_redis-${MODULE_REDIS_PV}.tar.gz )"
LICENSE="BSD"
RESTRICT="nomirror"
IUSE="debug fastcgi ipv6 perl ssl zlib libatomic"
IUSE_NGINX_MODULES=(addition flv imap random-index securelink status sub webdav redis rewrite)

# @VARIABLE: NGINX_MODULES
# @DESCRIPTION:
# This variable needs to be set prior pulling an ebuild and contains
# a space-separated list of tokens which represent the alias of a
# module to be found in IUSE_NGINX_MODULES
NGINX_MODULES=${NGINX_MODULES:-"rewrite"}

RDEPEND="nginx_modules_rewrite? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	perl? ( >=dev-lang/perl-5.8 )"
DEPEND="${RDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"

# ==============================================================================
# NGINX_MODULES parsing
# ==============================================================================
NUM_MODULES=${#IUSE_NGINX_MODULES[@]}
MY_MODS=""
index=0
while [ "${index}" -lt "${NUM_MODULES}" ] ; do
	IUSE="${IUSE} nginx_modules_${IUSE_NGINX_MODULES[${index}]}"
	let "index = ${index} + 1"
done

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================
# small and specialized instruments which serve only one purpose, each
nginx_makefile_check() {
	ebegin "checking make.conf for Nginx module settings"
	if ! $(grep -q '^USE_EXPAND=.*NGINX.*$' /etc/make.conf); then
		eerror "Please make sure you have defined following in your /etc/make.conf:"
		eerror "  USE_EXPAND=\"\${USE_EXPAND}\ NGINX_MODULES\""
		eerror "Then you can select modules for Nginx by:"
		eerror "  NGINX_MODULES=\"zlib rewrite\""
		elog "USE_EXPAND for NGINX_MODULES was not set. Aborting."
		die "USE_EXPAND for NGINX_MODULES was not set. Aborting."
	fi
	eend
}

nginx_create_user() {
	ebegin "Creating nginx user and group"
	enewgroup ${PN} || die "problem adding '${PN}' group"
	enewuser ${PN} -1 -1 -1 ${PN} || die "problem adding '${PN}' user"
	eend ${?}
}

# use_module: like the eutils' use_with function, but adds a specific pre- and suffix
# example: myconf+="$(use_module zlib)"
#          myconf+="$(use_module status http_stub_status)"

use_module() {
	[[ -z "${1}" ]] && die "usage: \$(use_module name) or \$(use_module name alias)"
	if useq ${1} || useq "nginx_modules_${1}" ; then
		echo " --with-http_${2:-${1}}_module"
	fi
}

# ==============================================================================
# FUNCTIONS CALLED IMMEDIATELY BY PORAGE
# ==============================================================================
# here the small functions are orchestrated
EXPORT_FUNCTIONS pkg_setup src_unpack src_configure src_compile src_install pkg_postinst

nginx_pkg_setup() {
	nginx_makefile_check
	nginx_create_user
	if use ipv6; then
		ewarn "Note that ipv6 support in nginx is still experimental."
		ewarn "Be sure to read comments on gentoo bug #274614"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=274614"
	fi
}

nginx_src_unpack() {
	unpack ${A}
	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make || die
	cd "${S}"
}

nginx_src_configure() {
	local myconf
	myconf=${1:-""}

	use debug			&& myconf+=" --with-debug"
	use ipv6			&& myconf+=" --with-ipv6"
	use perl			&& myconf+="$(use_module perl)"
	use ssl				&& myconf+="$(use_module ssl)"
	use zlib			|| myconf+=" --without-http_gzip_module"

	if use fastcgi; then
		myconf+=" --with-http_realip_module"
	else
		myconf+=" --without-http_fastcgi_module"
	fi
	use nginx_modules_addition	&& myconf+="$(use_module addition)"
	use nginx_modules_flv		&& myconf+="$(use_module flv)"
	if ! use nginx_modules_rewrite; then
		myconf+=" --without-pcre --without-http_rewrite_module"
	fi
	use nginx_modules_imap		&& myconf+=" --with-imap" # pop3/imap4 proxy support
	use nginx_modules_status	&& myconf+="$(use_module status stub_status)"
	use nginx_modules_webdav	&& myconf+="$(use_module wevdav dav)"
	use nginx_modules_sub		&& myconf+="$(use_module sub)"
	use nginx_modules_random-index	&& myconf+="$(use_module random-index random_index)"
	use nginx_modules_securelink	&& myconf+="$(use_module securelink secure_link)"
	(use libatomic || use arm)	&& myconf+=" --with-libatomic"

	# now come third-party modules
	use nginx_modules_redis		&& myconf+=" --add-module=../ngx_http_redis-${MODULE_REDIS_PV}"

	tc-export CC
	# nginx SEGFAULTs quite often with custom CFLAGS,
	# so we must remove them
	CFLAGS=""
	CXXFLAGS=""
	./configure \
		--prefix=/usr \
		--lock-path=/var/run \
		--conf-path=/etc/${PN}/${PN}.conf \
		--http-log-path=/var/log/${PN}/access_log \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--http-client-body-temp-path=/tmp \
		--http-proxy-temp-path=/tmp \
		--http-fastcgi-temp-path=/tmp \
		--with-md5-asm --with-sha1-asm \
		${myconf} || die "configure failed"
}

nginx_src_compile() {
	tc-export CC
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "failed to compile"
}

nginx_src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi}

	dosbin objs/nginx
	cp "${FILESDIR}"/nginx-r1 "${T}"/nginx
	doinitd "${T}"/nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	dodoc CHANGES{,.ru} README

	use perl && {
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}"|| die "failed to install perl stuff"
	}
}

nginx_pkg_postinst() {
	use ssl && {
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	}
}
