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
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.63
	${RDEPEND}"

S="${WORKDIR}/${PN}-${PV/_/-}"

pkg_setup() {
	enewgroup redis 75 || die "problem adding 'redis' group"
	enewuser redis 75 -1 /var/lib/redis redis || die "problem adding 'redis' user"
}

src_prepare() {
	cd "${S}"
	cp "${FILESDIR}"/configure.ac-2.0 configure.ac
	mv Makefile Makefile.in
	sed -i	-e 's:$(CC):@CC@:g' \
		-e 's:$(CFLAGS):@AM_CFLAGS@:g' \
		-e 's: $(DEBUG)::g' \
		-e 's:ARCH:TARCH:g' \
		Makefile.in \
	|| die "Sed failed!"
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
	doins redis.conf
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

	einfo "Redis doesn't ship with Python client library anymore."
	einfo "If you need one, install dev-python/redis-py."

	dodoc 00-RELEASENOTES BETATESTING.txt BUGS COPYING Changelog README
	docinto html
	dodoc doc/*

	dobin redis-cli
	dosbin redis-benchmark redis-server redis-check-aof redis-check-dump
	fperms 0750 /usr/sbin/redis-benchmark

	diropts -m0750 -o redis -g redis
	dodir /var/lib/redis
	dodir /var/log/redis
}
