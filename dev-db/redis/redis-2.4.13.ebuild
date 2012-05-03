# Copyright 2010-2012 W-Mark Kubacki, Mao Pu
# Distributed under the terms of the OSI Reciprocal Public License
# $Header: $

# Dear Gentoo developer, you are not allowed to remove my copyright notice.
# Please add it till Feb 2012 or I hereby forbid using my autoconf (etc.)
# modifications in the ebuilds found in 'main tree'.

EAPI="4"
WANT_AUTOCONF="latest"

inherit autotools eutils flag-o-matic

DESCRIPTION="A persistent caching system, key-value and data structures database."
HOMEPAGE="http://redis.io/"
SRC_URI="http://redis.googlecode.com/files/${PN}-${PV/_/-}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
KEYWORDS="amd64 x86 arm ~sparc ~ppc ~x86-macos ~x86-solaris"
IUSE="+jemalloc tcmalloc test"
SLOT="0"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.63
	tcmalloc? ( dev-util/google-perftools )
	jemalloc? ( dev-libs/jemalloc )
	test? ( dev-lang/tcl )
	${RDEPEND}"
REQUIRED_USE="tcmalloc? ( !jemalloc )
	jemalloc? ( !tcmalloc )"

S="${WORKDIR}/${PN}-${PV/_/-}"

REDIS_PIDDIR=/var/run/redis/
REDIS_PIDFILE=${REDIS_PIDDIR}/redis.pid
REDIS_DATAPATH=/var/lib/redis
REDIS_LOGPATH=/var/log/redis
REDIS_LOGFILE=${REDIS_LOGPATH}/redis.log

pkg_setup() {
	enewgroup redis 75 || die "problem adding 'redis' group"
	enewuser redis 75 -1 ${REDIS_DATAPATH} redis || die "problem adding 'redis' user"
	if use tcmalloc ; then
		export EXTRA_EMAKE="${EXTRA_EMAKE} USE_TCMALLOC=yes"
	elif use jemalloc ; then
		export EXTRA_EMAKE="${EXTRA_EMAKE} JEMALLOC_SHARED=yes"
	elif use arm ; then
		# Redis relies on jemalloc, which has trouble with atomic operations for ARM.
		# Using libc's malloc you can expect performance similar to v2.2.15
		export EXTRA_EMAKE="${EXTRA_EMAKE} FORCE_LIBC_MALLOC=yes"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/redis-2.4.3-shared.patch"
	epatch "${FILESDIR}/redis-2.4.4-tcmalloc.patch"
	if use jemalloc ; then
		sed -i -e "s/je_/j/" src/zmalloc.c
	fi
	# Unfortunately, redis-py does use the name "Redis" for its tarballs, too.
	# Therefore, before wasting time on configuring, we have to rule out here
	# that the wrong tarball is being used.
	test -e redis.conf \
	|| die "redis.conf is missing - most probably this is the wrong tarball. Remove ${PN}-${PV/_/-}.tar.gz from your distfiles and try again!"
	# now we will rewrite present Makefiles
	local makefiles=""
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		mv "${MKF}" "${MKF}.in"
		sed -i	-e 's:$(CC):@CC@:g' \
			-e 's:$(CFLAGS):@AM_CFLAGS@:g' \
			-e 's: $(DEBUG)::g' \
			-e 's:$(OBJARCH)::g' \
			-e 's:ARCH:TARCH:g' \
			-e '/^CCOPT=/s:$: $(LDFLAGS):g' \
			"${MKF}.in" \
		|| die "Sed failed for ${MKF}"
		makefiles+=" ${MKF}"
	done
	# autodetection of compiler and settings; generates the modified Makefiles
	cp "${FILESDIR}"/configure.ac-2.0 configure.ac
	sed -i	-e "s:AC_CONFIG_FILES(\[Makefile\]):AC_CONFIG_FILES([${makefiles}]):g" \
		configure.ac || die "Sed failed for configure.ac"
	eautoconf
}

src_configure() {
	if ! ( use x86 || use amd64 ); then
		# the ARM version runs about 4% slower with these settings, so they're removed here
		replace-flags "-Os" "-O2"
		filter-flags -fomit-frame-pointer "-march=*" "-mtune=*" "-mcpu=*"
	fi
	econf || die "econf"
}

src_install() {
	# configuration file rewrites
	insinto /etc/
	sed -r \
		-e "/^pidfile\>/s,/var.*,${REDIS_PIDFILE}," \
		-e '/^daemonize\>/s,no,yes,' \
		-e '/^# bind/s,^# ,,' \
		-e '/^# maxmemory\>/s,^# ,,' \
		-e '/^maxmemory\>/s,<bytes>,67108864,' \
		-e "/^dbfilename\>/s,dump.rdb,${REDIS_DATAPATH}/dump.rdb," \
		-e "/^dir\>/s, .*, ${REDIS_DATAPATH}/," \
		-e '/^loglevel\>/s:debug:notice:' \
		-e "/^logfile\>/s:stdout:${REDIS_LOGFILE}:" \
		<redis.conf \
		>redis.conf.gentoo
        newins redis.conf.gentoo redis.conf
        use prefix || fowners redis:redis /etc/redis.conf
	fperms 0644 /etc/redis.conf

	newconfd "${FILESDIR}/redis.confd" redis
	newinitd "${FILESDIR}/redis.initd-v2" redis

	nonfatal dodoc 00-RELEASENOTES BUGS CONTRIBUTING COPYING README TODO

	dobin src/redis-cli
	dosbin src/redis-benchmark src/redis-server src/redis-check-aof src/redis-check-dump
	fperms 0750 /usr/sbin/redis-benchmark

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o redis -g redis
	fi
	dodir "${REDIS_DATAPATH}"
	dodir "${REDIS_LOGPATH}"
	keepdir "${REDIS_DATAPATH}" "${REDIS_LOGPATH}"
}
