# Copyright 1999-2011 Gentoo Foundation
# Copyright 2011-2014 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="5"

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly
#   * does not need a patch for nginx core

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# devel_kit (https://github.com/simpl/ngx_devel_kit, BSD license)
DEVEL_KIT_MODULE_PV="0.2.19"
DEVEL_KIT_MODULE_P="ngx_devel_kit-${DEVEL_KIT_MODULE_PV}-r1"
DEVEL_KIT_MODULE_URI="https://github.com/simpl/ngx_devel_kit/archive/v${DEVEL_KIT_MODULE_PV}.tar.gz"
DEVEL_KIT_MODULE_WD="${WORKDIR}/ngx_devel_kit-${DEVEL_KIT_MODULE_PV}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.1"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"
HTTP_UPLOAD_PROGRESS_MODULE_SHA1="39e4d53"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/masterzen/nginx-upload-progress-module/tarball/v${HTTP_UPLOAD_PROGRESS_MODULE_PV}"

# http_redis (http://wiki.nginx.org/HttpRedis)
HTTP_REDIS_MODULE_P="ngx_http_redis-0.3.7"

# nginx-statsd (https://github.com/zebrafishlabs/nginx-statsd)
HTTP_STATSD_MODULE_P="nginx-statsd-20130318"
HTTP_STATSD_MODULE_PN="nginx-statsd"

# http_headers_more (http://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.25"
HTTP_HEADERS_MORE_MODULE_SHA1="0c6e05d"
HTTP_HEADERS_MORE_MODULE_PN="agentzh-headers-more-nginx-module"
HTTP_HEADERS_MORE_MODULE_P="${HTTP_HEADERS_MORE_MODULE_PN}-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_S="${HTTP_HEADERS_MORE_MODULE_PN}-${HTTP_HEADERS_MORE_MODULE_SHA1}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/${HTTP_HEADERS_MORE_MODULE_PN/-//}/tarball/v${HTTP_HEADERS_MORE_MODULE_PV}"

# http_lua (https://github.com/chaoslawful/lua-nginx-module, BSD license)
HTTP_LUA_MODULE_PV="0.9.12"
HTTP_LUA_MODULE_P="ngx_http_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_URI="https://github.com/chaoslawful/lua-nginx-module/archive/v${HTTP_LUA_MODULE_PV}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/lua-nginx-module-${HTTP_LUA_MODULE_PV}"

# http_echo (https://github.com/agentzh/echo-nginx-module)
HTTP_ECHO_MODULE_PV="0.56"
HTTP_ECHO_MODULE_SHA1="8f28ddf"
HTTP_ECHO_MODULE_PN="agentzh-echo-nginx-module"
HTTP_ECHO_MODULE_P="${HTTP_ECHO_MODULE_PN}-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_S="openresty-echo-nginx-module-${HTTP_ECHO_MODULE_SHA1}"
HTTP_ECHO_MODULE_URI="https://github.com/${HTTP_ECHO_MODULE_PN/-//}/tarball/v${HTTP_ECHO_MODULE_PV}"

# http_set_misc (https://github.com/agentzh/set-misc-nginx-module)
HTTP_SET_MISC_MODULE_PV="0.26"
HTTP_SET_MISC_MODULE_SHA1="1680123"
HTTP_SET_MISC_MODULE_PN="agentzh-set-misc-nginx-module"
HTTP_SET_MISC_MODULE_P="${HTTP_SET_MISC_MODULE_PN}-${HTTP_SET_MISC_MODULE_PV}"
HTTP_SET_MISC_MODULE_S="${HTTP_SET_MISC_MODULE_PN}-${HTTP_SET_MISC_MODULE_SHA1}"
HTTP_SET_MISC_MODULE_URI="https://github.com/${HTTP_SET_MISC_MODULE_PN/-//}/tarball/v${HTTP_SET_MISC_MODULE_PV}"

# http_redis2 (https://github.com/agentzh/redis2-nginx-module)
HTTP_REDIS2_MODULE_PV="0.11"
HTTP_REDIS2_MODULE_SHA1="828803d"
HTTP_REDIS2_MODULE_PN="agentzh-redis2-nginx-module"
HTTP_REDIS2_MODULE_P="${HTTP_REDIS2_MODULE_PN}-${HTTP_REDIS2_MODULE_PV}"
HTTP_REDIS2_MODULE_S="${HTTP_REDIS2_MODULE_PN}-${HTTP_REDIS2_MODULE_SHA1}"
HTTP_REDIS2_MODULE_URI="https://github.com/${HTTP_REDIS2_MODULE_PN/-//}/tarball/v${HTTP_REDIS2_MODULE_PV}"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.73"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"
HTTP_PUSH_MODULE_URI="https://github.com/slact/nginx_http_push_module/archive/v${HTTP_PUSH_MODULE_PV}.tar.gz"
HTTP_PUSH_MODULE_WD="${WORKDIR}/${HTTP_PUSH_MODULE_P}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.1"
HTTP_CACHE_PURGE_MODULE_P="ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"
HTTP_CACHE_PURGE_MODULE_URI="http://labs.frickle.com/files/${HTTP_CACHE_PURGE_MODULE_P}.tar.gz"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="http://labs.frickle.com/files/${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz"

# http_concat (https://github.com/alibaba/nginx-http-concat)
HTTP_CONCAT_MODULE_PV="1.2.2"
HTTP_CONCAT_MODULE_P="nginx-http-concat-${HTTP_CONCAT_MODULE_PV}"
HTTP_CONCAT_MODULE_URI="http://binhost.ossdl.de/distfiles/${HTTP_CONCAT_MODULE_P}.tbz2"

inherit eutils ssl-cert toolchain-funcs perl-module flag-o-matic user systemd versionator

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.org/"
SRC_URI="http://nginx.org/download/${P}.tar.gz
	${DEVEL_KIT_MODULE_URI} -> ${DEVEL_KIT_MODULE_P}.tar.gz
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_redis? ( http://people.freebsd.org/~osa/${HTTP_REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_statsd? ( https://binhost.ossdl.de/distfiles/${HTTP_STATSD_MODULE_P}.tar.xz )
	nginx_modules_http_echo? ( ${HTTP_ECHO_MODULE_URI} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_redis2? ( ${HTTP_REDIS2_MODULE_URI} -> ${HTTP_REDIS2_MODULE_P}.tar.gz )
	nginx_modules_http_push? ( ${HTTP_PUSH_MODULE_URI} -> ${HTTP_PUSH_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} )
	nginx_modules_http_concat? ( ${HTTP_CONCAT_MODULE_URI} )
	"
#	nginx_modules_http_set_misc? ( ${HTTP_SET_MISC_MODULE_URI} -> ${HTTP_SET_MISC_MODULE_P}.tar.gz )
RESTRICT="primaryuri"

LICENSE="BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
	"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip headers index limit_conn limit_req log map memcached proxy referer
rewrite scgi ssi upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition auth_request dav degradation flv geoip gunzip gzip_static
image_filter mp4 perl random_index realip secure_link spdy split_clients status
sub xslt"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
	http_concat
	http_upload_progress
	http_headers_more
	http_lua
	http_redis
	http_echo
	http_redis2
	http_push
	http_cache_purge
	http_slowfs_cache
	http_statsd
	"
#	http_set_misc

IUSE="aio debug +http +http-cache ipv6 libatomic +pcre +pcre-jit selinux ssl
paranoia userland_GNU vim-syntax"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

CDEPEND="
	pcre? ( >=dev-libs/libpcre-4.2 )
	pcre-jit? ( >=dev-libs/libpcre-8.20[jit] )
	selinux? ( sec-policy/selinux-nginx )
	ssl? ( >=dev-libs/openssl-1.0.2_pre20140805 )
	http-cache? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_spdy? ( >=dev-libs/openssl-1.0.1i )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_lua? ( || ( dev-lang/lua dev-lang/luajit ) )
	"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	ppc? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

REQUIRED_USE="pcre-jit? ( pcre )
	nginx_modules_http_lua? ( nginx_modules_http_rewrite )
	nginx_modules_http_spdy? ( ssl http )
	"

pkg_setup() {
	NGINX_HOME="/var/lib/nginx"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "${NGINX_HOME}" ${PN}
	eend $?

	if use libatomic; then
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use !http; then
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/0001-SSL-support-automatic-selection-of-ECDH-temporary-ke.patch"
	epatch "${FILESDIR}/nginx-1.3.4-if_modified_since.patch"
	epatch "${FILESDIR}/nginx-1.1.5-zero_filesize_check.patch"
	if use paranoia; then
		epatch "${FILESDIR}/nginx-1.5.6-random_dhparam.patch"
	else
		epatch "${FILESDIR}/nginx-1.5.6-3072-bit-dhparam.patch"
	fi
	epatch "${FILESDIR}/nginx-1.5.8-remove-RC4-from-the-list-of-default-ciphers.patch"

	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):' || die
	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die
	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done

	if use nginx_modules_http_lua; then
		cd "${HTTP_LUA_MODULE_WD}"
		epatch "${FILESDIR}/lua-nginx-module-0.9.12-compat-1.7.15-patch"
		cd - >/dev/null
	fi

	epatch_user
}

src_configure() {
	local myconf= http_enabled= mail_enabled=

	use aio       && myconf+=" --with-file-aio --with-aio_module"
	use debug     && myconf+=" --with-debug"
	use ipv6      && myconf+=" --with-ipv6"
	use libatomic && myconf+=" --with-libatomic"
	use pcre      && myconf+=" --with-pcre"
	use pcre-jit  && myconf+=" --with-pcre-jit"

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=" --without-http_${mod}_module"
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf+=" --with-http_${mod}_module"
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=" --with-http_realip_module"
	fi

	# third-party modules
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"
	fi

	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_HEADERS_MORE_MODULE_S}"
	fi

	if use nginx_modules_http_lua; then
		http_enabled=1
		myconf+=" --add-module=${DEVEL_KIT_MODULE_WD}"
		myconf+=" --add-module=${HTTP_LUA_MODULE_WD}"
	fi

	if use nginx_modules_http_redis; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_REDIS_MODULE_P}"
	fi

	if use nginx_modules_http_echo; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_ECHO_MODULE_S}"
	fi

#	if use nginx_modules_http_set_misc; then
#		http_enabled=1
#		myconf+=" --add-module=${WORKDIR}/${HTTP_SET_MISC_MODULE_S}"
#	fi

	if use nginx_modules_http_redis2; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_REDIS2_MODULE_S}"
	fi

	if use nginx_modules_http_push; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_WD}"
	fi

	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"
	fi

	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_SLOWFS_CACHE_MODULE_P}"
	fi

	if use nginx_modules_http_concat; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_CONCAT_MODULE_P}"
	fi

	if use nginx_modules_http_statsd; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_STATSD_MODULE_PN}"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=" --without-http-cache"
		use ssl && myconf+=" --with-http_ssl_module"
	else
		myconf+=" --without-http --without-http-cache"
	fi

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf+=" --without-mail_${mod}_module"
		fi
	done

	if [ $mail_enabled ]; then
		myconf+=" --with-mail"
		use ssl && myconf+=" --with-mail_ssl_module"
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=" --add-module=${mod}"
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	if ! use prefix; then
		myconf+=" --user=${PN} --group=${PN}"
	fi

	# CPU specific options
	use amd64 && myconf+=" --with-cpu-opt=amd64"

	./configure \
		--prefix="${EPREFIX}"/usr \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error_log \
		--pid-path="${EPREFIX}"/run/${PN}.pid \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/lib" \
		--http-log-path="${EPREFIX}"/var/log/${PN}/access_log \
		--http-client-body-temp-path="${EPREFIX}/${NGINX_HOME_TMP}"/client \
		--http-proxy-temp-path="${EPREFIX}/${NGINX_HOME_TMP}"/proxy \
		--http-fastcgi-temp-path="${EPREFIX}/${NGINX_HOME_TMP}"/fastcgi \
		--http-scgi-temp-path="${EPREFIX}/${NGINX_HOME_TMP}"/scgi \
		--http-uwsgi-temp-path="${EPREFIX}/${NGINX_HOME_TMP}"/uwsgi \
		${myconf} \
		${EXTRA_ECONF} || die "configure failed"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install

	cp "${FILESDIR}"/nginx.conf-r5 conf/nginx.conf
	sed -i	-e 's:worker_processes 2:worker_processes auto:g' \
		conf/nginx.conf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	dodir /etc/${PN}/vhosts.d
	insinto /etc/${PN}/vhosts.d
	doins "${FILESDIR}"/99_localhost.conf

	dodir /etc/${PN}/modules.d
	insinto /etc/${PN}/modules.d
	use nginx_modules_http_gzip	&& doins "${FILESDIR}"/01_gzip.conf
	use nginx_modules_http_geoip	&& doins "${FILESDIR}"/05_geoip.conf
	use nginx_modules_http_proxy	&& doins "${FILESDIR}"/05_proxy.conf
	use nginx_modules_http_browser	&& doins "${FILESDIR}"/07_browser.conf

	fperms 0750 /etc/nginx
	fowners ${PN}:0 /etc/nginx

	newinitd "${FILESDIR}"/nginx.init-r3 nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	doman man/nginx.8
	nonfatal dodoc CHANGES* README

	# just keepdir. do not copy the default htdocs files (bug #449136)
	keepdir /var/www/localhost
	rm -rf "${D}"/usr/html || die

	# set up a list of directories to keep
	local keepdir_list="${NGINX_HOME_TMP}"/client
	local module
	for module in proxy fastcgi scgi uwsgi; do
		use nginx_modules_http_${module} && keepdir_list+=" ${NGINX_HOME_TMP}/${module}"
	done

	keepdir /var/log/nginx ${keepdir_list}

	# this solves a problem with SELinux where nginx doesn't see the directories
	# as root and tries to create them as nginx
	fperms 0750 "${NGINX_HOME_TMP}"
	fowners ${PN}:0 "${NGINX_HOME_TMP}"

	fperms 0700 /var/log/nginx ${keepdir_list}
	fowners ${PN}:${PN} /var/log/nginx ${keepdir_list}

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx

	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor
		fixlocalpod
	fi

	if use nginx_modules_http_lua; then
		docinto ${HTTP_LUA_MODULE_P}
		nonfatal dodoc "${HTTP_LUA_MODULE_WD}"/{Changes,README.markdown}
	fi

	if use nginx_modules_http_cache_purge; then
		docinto ${HTTP_CACHE_PURGE_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_CACHE_PURGE_MODULE_P}/{CHANGES,README.md,TODO.md}
	fi

	if use nginx_modules_http_push; then
		docinto ${HTTP_PUSH_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_PUSH_MODULE_P}/{changelog.txt,protocol.txt,README}
	fi

	if use nginx_modules_http_slowfs_cache; then
		docinto ${HTTP_SLOWFS_CACHE_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_SLOWFS_CACHE_MODULE_P}/{CHANGES,README}
	fi
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${EROOT}"/etc/ssl/${PN}/${PN}.dhparam ]; then
			# implies prefix ${ROOT}
			install_cert /etc/ssl/${PN}/${PN}
			use prefix || chown ${PN}:${PN} "${EROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem,dhparam}
		fi

		einfo "For FIPS 140-2 compliance enable fips_mode in your openssl.cnf:"
		einfo ""
		einfo "  openssl_conf = openssl_options"
		einfo "  [ openssl_options ]"
		einfo "  alg_section = algs"
		einfo "  [ algs ]"
		einfo "  fips_mode = yes"
		einfo ""
		einfo "... and set this in your nginx.conf:"
		einfo ""
		einfo "  ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # excludes SSLv3"
		einfo "  ssl_ciphers FIPS:!3DES:!SHA1;"
		einfo "  #ssl_ecdh_curve prime256v1;"
		einfo "  ssl_prefer_server_ciphers on;"
		einfo ""
		einfo "DSA and ECDSA are prone to leak the key on loss of entropy."
		einfo "Don't enable them unless you have a reliable random number generator."
		einfo ""
		ewarn "Generate ssl_dhparam files for every certificate you use:"
		ewarn ""
		ewarn "  openssl dhparam -rand - 2048 > mydomain.tld.dhparam"
		if use paranoia; then
			ewarn ""
			ewarn "... and set ssl_dhparam accordingly or else every time Nginx"
			ewarn "starts a new dhparam will be generated, delaying that start."
			ewarn ""
		fi
		einfo ""
		einfo "Please note this new directive, with the recommended value being:"
		einfo ""
		einfo "  ssl_buffer_size 1370;"
	fi

	if use nginx_modules_http_lua && use nginx_modules_http_spdy; then
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua spdy\". For more info, see http://git.io/OldLsg"
	fi

#	if use arm64; then
#		# arm64 knows different cache lines
#		einfo 'add EXTRA_ECONF=" NGX_CPU_CACHE_LINE=64" if applicable'
#	fi

	# This is the proper fix for bug #458726/#469094, resp. CVE-2013-0337 for
	# existing installations
	local fix_perms=0

	for rv in ${REPLACING_VERSIONS} ; do
		version_compare ${rv} 1.4.1-r2
		[[ $? -eq 1 ]] && fix_perms=1
	done

	if [[ $fix_perms -eq 1 ]] ; then
		ewarn "To fix a security bug (CVE-2013-0337, bug #458726) had the following"
		ewarn "directories the world-readable bit removed (if set):"
		ewarn "  ${EPREFIX}/var/log/nginx"
		ewarn "  ${EPREFIX}${NGINX_HOME_TMP}/{,client,proxy,fastcgi,scgi,uwsgi}"
		ewarn "Check if this is correct for your setup before restarting nginx!"
		ewarn "This is a one-time change and will not happen on subsequent updates."
		ewarn "Furthermore nginx' temp directories got moved to ${NGINX_HOME_TMP}"
		chmod -f o-rwx "${EPREFIX}"/var/log/nginx "${EPREFIX}/${NGINX_HOME_TMP}"/{,client,proxy,fastcgi,scgi,uwsgi}
	fi

	# If the nginx user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c 'cd /var/log/nginx/ && ls' nginx >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn "Please make sure that the nginx user or group has at least"
		ewarn "'rx' permissions on /var/log/nginx (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi
}
