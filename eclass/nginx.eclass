# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Original Author: W-Mark Kubacki <wmark@hurrikane.de>
# Purpose: Collects common Nginx specific ebuild functions along with helper
#          functions.

EAPI="2"

inherit eutils ssl-cert toolchain-funcs

MODULE_DRIZZLE_PV=${MODULE_DRIZZLE_PV:-"aa3269a"}
MODULE_RDS_JSON_PV=${MODULE_RDS_JSON_PV:-"9cf3bef"}
MODULE_XSS_PV=${MODULE_XSS_PV:-"58732b0"}
MODULE_ACLANG_PV=${MODULE_ACLANG_PV:-"20081217"}
MODULE_REDIS_PV=${MODULE_REDIS_PV:-"0.3.1"}

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.net/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz
	nginx_modules_drizzle? ( http://binhost.ossdl.de/distfiles/chaoslawful-drizzle-nginx-module-${MODULE_DRIZZLE_PV}.tar.gz )
	nginx_modules_rds_json? ( http://binhost.ossdl.de/distfiles/agentzh-rds-json-nginx-module-${MODULE_RDS_JSON_PV}.tar.gz )
	nginx_modules_xss? ( http://binhost.ossdl.de/distfiles/agentzh-xss-nginx-module-${MODULE_XSS_PV}.tar.gz )
	nginx_modules_accept_language? ( http://binhost.ossdl.de/distfiles/nginx_accept_language_module-${MODULE_ACLANG_PV}.tbz2 )
	nginx_modules_redis? ( http://people.freebsd.org/~osa/ngx_http_redis-${MODULE_REDIS_PV}.tar.gz )"
LICENSE="BSD"
RESTRICT="primaryuri"
IUSE="debug fastcgi ipv6 perl ssl zlib libatomic"
IUSE_NGINX_MODULES=(addition access auth_basic autoindex empty_gif \
flv geo geoip imap limit_zone limit_req map memcached random-index perl redis \
referer proxy securelink status sub rewrite upstream_ip_hash webdav \
accept_language xss drizzle rds_json gzip_static)

# @VARIABLE: NGINX_DEFAULT_MODULES
# @DESCRIPTION:
# Contains a space-separated list of tokens which represent the alias of a
# module to be found in IUSE_NGINX_MODULES and which correspond to modules
# which "are automatically compiled in unless explicitly disabled".
NGINX_DEFAULT_MODULES="rewrite autoindex auth_basic access empty_gif \
limit_zone limit_req geo map memcached referer rewrite proxy \
upstream_ip_hash"

# @VARIABLE: NGINX_MODULES
# @DESCRIPTION:
# This variable needs to be set prior pulling an ebuild and contains
# a space-separated list of tokens which represent the alias of a
# module to be found in IUSE_NGINX_MODULES
NGINX_MODULES=${NGINX_MODULES:-${NGINX_DEFAULT_MODULES}}

# Modules which cannot be deselected:
# static, index, browser

RDEPEND="nginx_modules_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_geoip? ( dev-libs/geoip )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	nginx_modules_drizzle? ( >=dev-db/libdrizzle-0.6 )
	nginx_modules_perl? ( >=dev-lang/perl-5.8 )"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.1.7.16
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"

# ==============================================================================
# NGINX_MODULES parsing
# ==============================================================================
NUM_MODULES=${#IUSE_NGINX_MODULES[@]}
index=0
while [ "${index}" -lt "${NUM_MODULES}" ] ; do
	if has ${IUSE_NGINX_MODULES[${index}]} ${NGINX_DEFAULT_MODULES} ; then
		IUSE+=" +nginx_modules_${IUSE_NGINX_MODULES[${index}]}"
	else
		IUSE+=" nginx_modules_${IUSE_NGINX_MODULES[${index}]}"
	fi
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
		eerror "  NGINX_MODULES=\"rewrite autoindex auth_basic access \\"
		eerror "  limit_zone limit_req geo map referer rewrite proxy upstream_ip_hash\""
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
	if useq "nginx_modules_${1}" ; then
		if ! has ${1} ${NGINX_DEFAULT_MODULES} ; then
			echo " --with-http_${2:-${1}}_module"
		fi
	else
		if has ${1} ${NGINX_DEFAULT_MODULES} ; then
			echo " --without-http_${2:-${1}}_module"
		fi
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

	# active/deactivate all modules, except those for "special treatment"
	SPECIAL_TREATMENT="accept_language addition drizzle imap random-index rds_json redis rewrite securelink status webdav xss zlib"
	index=0
	while [ "${index}" -lt "${NUM_MODULES}" ] ; do
		if ! has ${IUSE_NGINX_MODULES[${index}]} ${SPECIAL_TREATMENT} ; then
			myconf+="$(use_module ${IUSE_NGINX_MODULES[${index}]})"
		fi
		let "index = ${index} + 1"
	done

	# now come the modules which qualified for "special treatment"
	# by needing renames or by being pulled in by casual use flags
	# or which are enable-only
	use debug			&& myconf+=" --with-debug"
	use ipv6			&& myconf+=" --with-ipv6"
	use ssl				&& myconf+=" --with-http_ssl_module"
	use zlib			|| myconf+=" --without-http_gzip_module"

	use nginx_modules_addition	&& myconf+="$(use_module addition)"
	if use fastcgi; then
		myconf+=" --with-http_realip_module"
	else
		myconf+=" --without-http_fastcgi_module"
	fi
	if ! use nginx_modules_rewrite; then
		myconf+=" --without-pcre --without-http_rewrite_module"
	fi
	use nginx_modules_imap		&& myconf+=" --with-imap" # pop3/imap4 proxy support
	use nginx_modules_status	&& myconf+="$(use_module status stub_status)"
	use nginx_modules_webdav	&& myconf+="$(use_module webdav dav)"
	use nginx_modules_random-index	&& myconf+="$(use_module random-index random_index)"
	use nginx_modules_securelink	&& myconf+="$(use_module securelink secure_link)"
	(use libatomic || use arm)	&& myconf+=" --with-libatomic"

	# now come third-party modules, order matters
	use nginx_modules_redis		&& myconf+=" --add-module=../ngx_http_redis-${MODULE_REDIS_PV}"
	use nginx_modules_accept_language	&& myconf+=" --add-module=../nginx_accept_language_module"
	use nginx_modules_xss		&& myconf+=" --add-module=../agentzh-xss-nginx-module-${MODULE_XSS_PV}"
	use nginx_modules_rds_json	&& myconf+=" --add-module=../agentzh-rds-json-nginx-module-${MODULE_RDS_JSON_PV}"
	use nginx_modules_drizzle	&& myconf+=" --add-module=../chaoslawful-drizzle-nginx-module-${MODULE_DRIZZLE_PV}"

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
