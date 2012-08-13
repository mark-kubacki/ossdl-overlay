# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils python flag-o-matic

DESCRIPTION="Persistent distributed key-value data caching system."
HOMEPAGE="http://code.google.com/p/redis/"
SRC_URI="http://redis.googlecode.com/files/${PN}-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="amd64 x86 ~arm ~sparc ~ppc"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.63
	${RDEPEND}"

pkg_setup() {
	enewgroup redis 75 || die "problem adding 'redis' group"
	enewuser redis 75 -1 /var/lib/redis redis || die "problem adding 'redis' user"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp "${FILESDIR}"/configure.ac-1.02 configure.ac
	mv Makefile Makefile.in
	sed -i	-e 's:$(CC):@CC@:g' \
		-e 's:$(CFLAGS):@AM_CFLAGS@:g' \
		-e 's: $(DEBUG)::g' \
		-e 's:ARCH:TARCH:g' \
		Makefile.in \
	|| die "Sed failed!"

	eautoconf
}

src_compile() {
	if ! ( use x86 || use amd64 ); then
		replace-flags "-Os" "-O2"
		filter-flags -fomit-frame-pointer "-march=*" "-mtune=*" "-mcpu=*"
	fi

	econf ${myconf} || die "econf"
	emake || die "emake"
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

	dodoc 00-RELEASENOTES BETATESTING.txt BUGS COPYING Changelog README TODO
	docinto html
	dodoc doc/*

	dobin redis-cli
	dosbin redis-benchmark redis-server
	fperms 0750 /usr/sbin/redis-benchmark

	diropts -m0750 -o redis -g redis
	dodir /var/lib/redis
	dodir /var/log/redis
}
