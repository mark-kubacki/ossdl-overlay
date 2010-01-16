# Copyright 1999-2009 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils ssl-cert toolchain-funcs

DESCRIPTION="Robust, small and high performance http and reverse proxy server"

HOMEPAGE="http://nginx.net/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz
	nginx_modules_redis? ( http://people.freebsd.org/~osa/ngx_http_redis-0.3.1.tar.gz )"
LICENSE="BSD"
RESTRICT="nomirror"
SLOT="0"
KEYWORDS="amd64 ppc x86 arm sparc ~x86-fbsd"
IUSE="addition debug fastcgi flv imap ipv6 pcre perl random-index securelink ssl status sub webdav zlib libatomic"

IUSE_NGINX_MODULES=(redis memcached)
NUM_MODULES=${#IUSE_NGINX_MODULES[@]}
index=0
while [ "${index}" -lt "${NUM_MODULES}" ] ; do
	IUSE="${IUSE} nginx_modules_${IUSE_NGINX_MODULES[${index}]}"
	let "index = ${index} + 1"
done

DEPEND="dev-lang/perl
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	libatomic? ( dev-libs/libatomic_ops )
	arm? ( dev-libs/libatomic_ops )
	perl? ( >=dev-lang/perl-5.8 )"

nginx_makefile_check() {
	ebegin "checking make.conf for Nginx module settings"
	if ! $(grep -q '^USE_EXPAND=.*NGINX.*$' /etc/make.conf); then
		eerror "Please make sure you have defined following in your /etc/make.conf:"
		eerror "  USE_EXPAND=\"\${USE_EXPAND}\ NGINX_MODULES\""
		eerror "Then you can select modules for Nginx by:"
		eerror "  NGINX_MODULES=\"addition zlib rewrite dav sub\""
		elog "USE_EXPAND for NGINX_MODULES was not set. Aborting."
		die "USE_EXPAND for NGINX_MODULES was not set. Aborting."
	fi
	eend
}

pkg_setup() {
	nginx_makefile_check
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}
	if use ipv6; then
		ewarn "Note that ipv6 support in nginx is still experimental."
		ewarn "Be sure to read comments on gentoo bug #274614"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=274614"
	fi
}

src_unpack() {
	unpack ${A}
	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make || die
	cd "${S}"
	epatch "${FILESDIR}/nginx-0.8.27-zero_filesize_check.patch"
}

src_compile() {
	local myconf

	# threads support is broken atm.
	#
	# if use threads; then
	# 	einfo
	# 	ewarn "threads support is experimental at the moment"
	# 	ewarn "do not use it on production systems - you've been warned"
	# 	einfo
	# 	myconf="${myconf} --with-threads"
	# fi

	use addition	&& myconf="${myconf} --with-http_addition_module"
	use ipv6	&& myconf="${myconf} --with-ipv6"
	use fastcgi	|| myconf="${myconf} --without-http_fastcgi_module"
	use fastcgi	&& myconf="${myconf} --with-http_realip_module"
	use flv		&& myconf="${myconf} --with-http_flv_module"
	use zlib	|| myconf="${myconf} --without-http_gzip_module"
	use pcre	|| {
		myconf="${myconf} --without-pcre --without-http_rewrite_module"
	}
	use debug	&& myconf="${myconf} --with-debug"
	use ssl		&& myconf="${myconf} --with-http_ssl_module"
	use imap	&& myconf="${myconf} --with-imap" # pop3/imap4 proxy support
	use perl	&& myconf="${myconf} --with-http_perl_module"
	use status	&& myconf="${myconf} --with-http_stub_status_module"
	use webdav	&& myconf="${myconf} --with-http_dav_module"
	use sub		&& myconf="${myconf} --with-http_sub_module"
	use random-index	&& myconf="${myconf} --with-http_random_index_module"
	use securelink	&& myconf="${myconf} --with-http_secure_link_module"
	(use libatomic || use arm)	&& myconf="${myconf} --with-libatomic"

	# now come modules
	use nginx_modules_redis	&& myconf+=" --add-module=../ngx_http_redis-0.3.1"

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

	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "failed to compile"
}

src_install() {
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

pkg_postinst() {
	use ssl && {
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	}
}
