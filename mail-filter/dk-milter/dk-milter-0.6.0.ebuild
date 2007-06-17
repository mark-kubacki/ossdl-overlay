# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A milter-based application provide DomainKeys service"
HOMEPAGE="http://sourceforge.net/projects/dk-milter/"
SRC_URI="mirror://sourceforge/dk-milter/${P}.tar.gz"
LICENSE="Sendmail-Open-Source"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-libs/openssl
	>=sys-libs/db-3.2
	|| ( mail-filter/libmilter >=mail-mta/sendmail-8.12 )"

S=${WORKDIR}/${P}

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/milter milter
}

src_unpack() {
	unpack "${A}" && cd "${S}"

	# Postfix queue ID patch. See MILTER_README.html#workarounds
	epatch "${FILESDIR}"/${PN}-0.4.1-queueID.patch

	confCCOPTS="${CFLAGS}"
	conf_libmilter_INCDIRS="-I/usr/include/libmilter"
	sed -e "s:@@confCCOPTS@@:${confCCOPTS}:" \
		-e "s:@@conf_libmilter_INCDIRS@@:${conf_libmilter_INCDIRS}:" \
		"${FILESDIR}"/site.config.m4 > "${S}"/devtools/Site/site.config.m4 \
		|| die "sed failed"
}

src_install() {
	OBJDIR="obj.`uname -s`.`uname -r`.`arch`"

	# prepare directory for private keys.
	dodir /etc/mail/dk-filter
	keepdir /etc/mail/dk-filter
	fowners milter:milter /etc/mail/dk-filter
	fperms 700 /etc/mail/dk-filter

	dodir /usr/bin /usr/share/man/man8

	make DESTDIR=${D} MANROOT=/usr/share/man/man \
		install -C "${OBJDIR}"/dk-filter \
			|| die "make install failed"

	doman dk-filter/dk-filter.8
	dobin "$FILESDIR"/gentxt.sh || die "dobin failed"

	newinitd "${FILESDIR}/dk-filter.init" dk-filter \
		|| die "newinitd failed"
	newconfd "${FILESDIR}/dk-filter.conf" dk-filter \
		|| die "newconfd failed"
}
