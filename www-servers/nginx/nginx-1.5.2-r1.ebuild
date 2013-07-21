# Copyright 1999-2011 Gentoo Foundation
# Copyright 2011-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="4"

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.0"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"
HTTP_UPLOAD_PROGRESS_MODULE_SHA1="a788dea"
HTTP_UPLOAD_PROGRESS_MODULE_URI="http://github.com/masterzen/nginx-upload-progress-module/tarball/v${HTTP_UPLOAD_PROGRESS_MODULE_PV}"

# http_headers_more (http://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.21"
HTTP_HEADERS_MORE_MODULE_P="ngx-http-headers-more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_SHA1="ec05b89"
HTTP_HEADERS_MORE_MODULE_URI="http://github.com/agentzh/headers-more-nginx-module/tarball/v${HTTP_HEADERS_MORE_MODULE_PV}"

# http_passenger (http://www.modrails.com/, https://github.com/FooBarWidget/passenger, MIT license)
# TODO: currently builds some stuff in src_configure
# Please report runtime and compilation errors to Mark <wmark@hurrikane.de>
PASSENGER_PV="4.0.5"
USE_RUBY="ruby18 ree18 ruby19"
RUBY_OPTIONAL="yes"

# http_redis (http://wiki.nginx.org/HttpRedis)
HTTP_REDIS_MODULE_P="ngx_http_redis-0.3.6"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.692"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"
HTTP_PUSH_MODULE_URI="http://pushmodule.slact.net/downloads/${HTTP_PUSH_MODULE_P}.tar.gz"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.1"
HTTP_CACHE_PURGE_MODULE_P="ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"
HTTP_CACHE_PURGE_MODULE_URI="http://labs.frickle.com/files/${HTTP_CACHE_PURGE_MODULE_P}.tar.gz"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="http://labs.frickle.com/files/${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz"

# http_concat (https://github.com/taobao/nginx-http-concat)
HTTP_CONCAT_MODULE_PV="1.2.2"
HTTP_CONCAT_MODULE_P="nginx-http-concat-${HTTP_CONCAT_MODULE_PV}"
HTTP_CONCAT_MODULE_URI="http://binhost.ossdl.de/distfiles/${HTTP_CONCAT_MODULE_P}.tbz2"

inherit eutils ssl-cert toolchain-funcs perl-module ruby-ng flag-o-matic

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.org/"
SRC_URI="http://nginx.org/download/${P}.tar.gz
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? ( http://s3.amazonaws.com/phusion-passenger/releases/passenger-${PASSENGER_PV}.tar.gz )
	nginx_modules_http_redis? ( http://people.freebsd.org/~osa/${HTTP_REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_push? ( ${HTTP_PUSH_MODULE_URI} )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} )
	nginx_modules_http_concat? ( ${HTTP_CONCAT_MODULE_URI} )
	"
RESTRICT="primaryuri"

LICENSE="as-is BSD BSD-2 GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 arm arm64 ~x86-fbsd"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip limit_req limit_zone map memcached proxy referer rewrite scgi ssi
split_clients upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition dav degradation flv geoip gunzip gzip_static image_filter
mp4 perl random_index realip secure_link stub_status sub xslt spdy"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
	http_concat
	http_upload_progress
	http_headers_more
	http_passenger
	http_redis
	http_push
	http_cache_purge
	http_slowfs_cache
	"

IUSE="aio debug +http +http-cache ipv6 libatomic +pcre ssl vim-syntax"

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
	ssl? ( >=dev-libs/openssl-1.0.1 )
	http-cache? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_geo? ( dev-libs/geoip )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_passenger? (
		$(ruby_implementation_depend ruby18)
		>=dev-ruby/rubygems-0.9.0
		>=dev-ruby/rake-0.8.1
		>=dev-ruby/fastthread-1.0.1
		>=dev-ruby/rack-1.0.0
		dev-libs/libev
	)
	nginx_modules_http_spdy? ( >=dev-libs/openssl-1.0.1 )"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	ppc? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"
S="${WORKDIR}/${P}"

REQUIRED_USE="nginx_modules_http_spdy? ( ssl http )"

pkg_setup() {
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}

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

	if use nginx_modules_http_passenger; then
		ruby-ng_pkg_setup
		use debug && append-flags -DPASSENGER_DEBUG
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	epatch "${FILESDIR}/nginx-1.3.4-if_modified_since.patch"
	epatch "${FILESDIR}/nginx-1.1.5-zero_filesize_check.patch"

	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make
	sed -i 's/1001011/1001012/' "${S}"/src/core/nginx.h

	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-${PASSENGER_PV}
		epatch \
			"${FILESDIR}/passenger-3.0.1-missing-include.patch"

		sed -i \
			-e 's|/usr/lib/phusion-passenger/agents|/usr/libexec/passenger/agents|' \
			-e 's|/usr/share/phusion-passenger/helper-scripts|/usr/libexec/passenger/bin|' \
			-e "s|/usr/share/doc/phusion-passenger|/usr/share/doc/${PF}|" \
			lib/phusion_passenger.rb ext/common/ResourceLocator.h || die "sed failed"
	fi
}

src_configure() {
	local myconf= http_enabled= mail_enabled=

	use aio       && myconf+=" --with-file-aio --with-aio_module"
	use debug     && myconf+=" --with-debug"
	use ipv6      && myconf+=" --with-ipv6"
	use libatomic && myconf+=" --with-libatomic"
	use pcre      && myconf+=" --with-pcre --with-pcre-jit"

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
		myconf+=" --add-module=${WORKDIR}/agentzh-headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_SHA1}"
	fi

	if use nginx_modules_http_passenger; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/passenger-${PASSENGER_PV}/ext/nginx"
	fi

	if use nginx_modules_http_redis; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_REDIS_MODULE_P}"
	fi

	if use nginx_modules_http_push; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_P}"
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

	# CPU specific options
	use amd64 && myconf+=" --with-cpu-opt=amd64"

	./configure \
		--prefix=/usr \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/${PN}/${PN}.conf \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--lock-path=/var/lock/nginx.lock \
		--user=${PN} --group=${PN} \
		--with-cc-opt="-I${ROOT}usr/include" \
		--with-ld-opt="-L${ROOT}usr/lib" \
		--http-log-path=/var/log/${PN}/access_log \
		--http-client-body-temp-path=/var/tmp/${PN}/client \
		--http-proxy-temp-path=/var/tmp/${PN}/proxy \
		--http-fastcgi-temp-path=/var/tmp/${PN}/fastcgi \
		--http-scgi-temp-path=/var/tmp/${PN}/scgi \
		--http-uwsgi-temp-path=/var/tmp/${PN}/uwsgi \
		${myconf} \
		${EXTRA_ECONF} || die "configure failed"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi,scgi,uwsgi}
	keepdir /var/www/localhost/htdocs

	dosbin objs/nginx
	newinitd "${FILESDIR}"/nginx.init-r3 nginx

	cp "${FILESDIR}"/nginx.conf-r5 conf/nginx.conf
	sed -i	-e 's:worker_processes 2:worker_processes auto:g' \
		conf/nginx.conf
	rm conf/win-utf conf/koi-win conf/koi-utf

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

	doman man/nginx.8
	nonfatal dodoc CHANGES* README

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx

	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		fixlocalpod
	fi

	if use nginx_modules_http_push; then
		docinto ${HTTP_PUSH_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_PUSH_MODULE_P}/{changelog.txt,protocol.txt,README}
	fi

	if use nginx_modules_http_cache_purge; then
		docinto ${HTTP_CACHE_PURGE_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_CACHE_PURGE_MODULE_P}/{CHANGES,README.md}
	fi

	if use nginx_modules_http_slowfs_cache; then
		docinto ${HTTP_SLOWFS_CACHE_MODULE_P}
		nonfatal dodoc "${WORKDIR}"/${HTTP_SLOWFS_CACHE_MODULE_P}/{CHANGES,README}
	fi

	if use nginx_modules_http_passenger; then
		# passengers Rakefile is so horribly broken that we have to do it
		# manually
		cd "${WORKDIR}"/passenger-${PASSENGER_PV}

		for RUBY in $(ruby_get_use_implementations); do
			# odd: on some machines the above variable-assignment isn't sufficient
			export RUBY="${RUBY}"

			insinto $(${RUBY} -rrbconfig -e 'print Config::CONFIG["archdir"]')
			insopts -m 0755
			doins libout/ruby/*/passenger_native_support.so
			doruby -r lib/phusion_passenger lib/phusion_passenger.rb
		done

		exeinto /usr/bin
		doexe bin/passenger-memory-stats bin/passenger-status

		exeinto /usr/libexec/passenger/bin
		doexe helper-scripts/prespawn

		exeinto /usr/libexec/passenger/agents
		doexe agents/Passenger{LoggingAgent,Watchdog}

		exeinto /usr/libexec/passenger/agents/nginx
		doexe agents/PassengerHelperAgent
	fi
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
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
		einfo "  ssl_ciphers FIPS:!ECDSA:!3DES:!SHA1;"
		einfo "  #ssl_ecdh_curve prime256v1;"
		einfo "  ssl_prefer_server_ciphers on;"
		einfo ""
		einfo "DSA and ECDSA are prone to leak the key on loss of entropy."
		einfo "Don't enable them unless you have a reliable random number generator."
		einfo "3DES can be exploitet in asymmetrical (resource-consumption) attacks."
	fi

	if use nginx_modules_http_passenger; then
		einfo ""
		einfo "'passenger-spawn-server' has been renamed to 'prespawn'"
		einfo ""
	fi

	if use arm64; then
		# arm64 knows different cache lines
		einfo 'add EXTRA_ECONF=" NGX_CPU_CACHE_LINE=64" if applicable'
	fi
}
