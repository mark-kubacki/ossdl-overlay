# Copyright 2010 W-Mark Kubacki, Wais Darwish
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"

inherit autotools eutils python flag-o-matic

DESCRIPTION="Persistent distributed key-value data caching system."
HOMEPAGE="http://code.google.com/p/redis/"
SRC_URI="http://redis.googlecode.com/files/${PN}-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 ~arm"
IUSE="python"
SLOT="0"

RDEPEND="python? ( >=dev-lang/python-2.5 )"
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

	if use python ; then
		insinto $(python_get_sitedir)/redis
		touch "${D}$(python_get_sitedir)/redis/__init__.py"
		doins client-libraries/python/redis.py
	fi

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
