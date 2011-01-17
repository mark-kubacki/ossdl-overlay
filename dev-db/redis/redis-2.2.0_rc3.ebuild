# Copyright 2010 W-Mark Kubacki, Mao Pu
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOCONF="latest"

inherit autotools eutils flag-o-matic

DESCRIPTION="A persistent caching system, key-value and data structures database."
HOMEPAGE="http://code.google.com/p/redis/"
SRC_URI="http://redis.googlecode.com/files/${PN}-${PV/_/-}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~sparc ~ppc"
IUSE="tcmalloc"
SLOT="0"

RDEPEND=""
DEPEND="
	>=sys-devel/autoconf-2.63
	tcmalloc? ( dev-util/google-perftools )
	${RDEPEND}"

S="${WORKDIR}/${PN}-${PV/_/-}"

pkg_setup() {
	enewgroup redis 75 || die "problem adding 'redis' group"
	enewuser redis 75 -1 /var/lib/redis redis || die "problem adding 'redis' user"
	# set tcmalloc-variable for the build as specified in
	# https://github.com/antirez/redis/blob/2.2/README. If build system gets
	# better integrated into autotools, replace with append-flags and
	# append-ldflags in src_configure()
	use tcmalloc && export EXTRA_EMAKE="${EXTRA_EMAKE} USE_TCMALLOC=yes"
}

src_prepare() {
	cd "${S}"
	# now we will rewrite present Makefiles
	local makefiles=""
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		mv "${MKF}" "${MKF}.in"
		sed -i	-e 's:$(CC):@CC@:g' \
			-e 's:$(CFLAGS):@AM_CFLAGS@:g' \
			-e 's: $(DEBUG)::g' \
			-e 's:ARCH:TARCH:g' \
			"${MKF}.in" \
		|| die "Sed failed for ${MKF}"
		makefiles+=" ${MKF}"
	done
	# autodetection of compiler and settings; generates the modified Makefiles
	cp "${FILESDIR}"/configure.ac-2.2 configure.ac
	sed -i	-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoconf
}

src_configure() {
	if ! ( use x86 || use amd64 ); then
		replace-flags "-Os" "-O2"
		filter-flags -fomit-frame-pointer "-march=*" "-mtune=*" "-mcpu=*"
	fi
	econf ${myconf} || die "econf"
}


src_install() {
	# configuration file rewrites
	insinto /etc/
	doins redis.conf || ewarn "mysteriously the configuration file is missing"
	dosed "s:daemonize no:daemonize yes:g" /etc/redis.conf
	dosed "s:# bind:bind:g" /etc/redis.conf
	dosed "s:dbfilename :dbfilename /var/lib/redis/:g" /etc/redis.conf
	dosed "s:dir ./:dir /var/lib/redis/:g" /etc/redis.conf
	dosed "s:loglevel debug:loglevel notice:g" /etc/redis.conf
	dosed "s:logfile stdout:logfile /var/log/redis/redis.log:g" /etc/redis.conf
	fowners redis:redis /etc/redis.conf
	fperms 0644 /etc/redis.conf

	newconfd "${FILESDIR}/redis.confd" redis
	newinitd "${FILESDIR}/redis.initd" redis

	dodoc 00-RELEASENOTES BUGS Changelog CONTRIBUTING COPYING README TODO
	dodoc design-documents/*
	docinto html
	dodoc doc/*

	dobin src/redis-cli \
	|| die "the redis command line client could not be found"
	dosbin src/redis-benchmark src/redis-server src/redis-check-aof src/redis-check-dump \
	|| die "some redis executables could not be found"
	fperms 0750 /usr/sbin/redis-benchmark

	diropts -m0750 -o redis -g redis
	dodir /var/lib/redis
	dodir /var/log/redis
}

pkg_postinst() {
	einfo "New features of Redis you want to consider enabling in redis.conf:"
	einfo " * unix sockets (using this is highly recommended)"
	einfo " * logging to syslog"
	einfo " * VM aka redis' own swap mechanism"
}
