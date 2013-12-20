# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dk-milter/dk-milter-1.0.0.ebuild,v 1.1 2008/06/08 09:26:53 mrness Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A milter-based application provide DomainKeys service"
HOMEPAGE="http://sourceforge.net/projects/dk-milter/"
SRC_URI="mirror://sourceforge/dk-milter/${P}.tar.gz"

LICENSE="Sendmail-Open-Source"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6"

RDEPEND="dev-libs/openssl
	>=sys-libs/db-3.2"
DEPEND="${RDEPEND}
	|| ( mail-filter/libmilter mail-mta/sendmail )" # libmilter is a static library

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 -1 milter
}

src_unpack() {
	unpack ${A}

	local ENVDEF=""
	use ipv6 && ENVDEF="${ENVDEF} -DNETINET6"
	sed -e "s:@@CFLAGS@@:${CFLAGS}:" -e "s/@@ENVDEF@@/${ENVDEF}/" \
		"${FILESDIR}/gentoo.config.m4" > "${S}/devtools/Site/site.config.m4" \
		|| die "failed to generate site.config.m4"
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	# no other program need to read from here
	dodir /etc/mail/dk-filter
	fowners milter:milter /etc/mail/dk-filter
	fperms 700 /etc/mail/dk-filter

	newinitd "${FILESDIR}/dk-filter.init" dk-filter \
		|| die "newinitd failed"
	newconfd "${FILESDIR}/dk-filter.conf" dk-filter \
		|| die "newconfd failed"

	# prepare directory for .pid and .sock files
	dodir /var/run/dk-filter
	fowners milter:milter /var/run/dk-filter

	dodir /usr/bin
	emake -j1 DESTDIR="${D}" \
		SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
		install || die "make install failed"

	# man build is broken; do man page installation by hand
	doman */*.8

	# some people like docs
	dodoc README RELEASE_NOTES KNOWNBUGS *.txt
}

pkg_postinst() {
	ewarn "DomainKeys RFC is obsoleted by DKIM and therefore you should only use"
	ewarn "dk-milter for verifying mail signed with DomainKeys-Signature."
	echo
	elog "However, if you still want to use this in sign mode, you should run"
	elog "	emerge --config ${CATEGORY}/${PN}"
	elog "It will help you create your key and give you hints on how"
	elog "to configure your DNS and MTA."
}

pkg_config() {
	local selector pubkey

	read -p "Enter the selector name (default ${HOSTNAME}): " selector
	[[ -n "${selector}" ]] || selector=${HOSTNAME}
	if [[ -z "${selector}" ]]; then
		eerror "Oddly enough, you don't have a HOSTNAME."
		return 1
	fi
	if [[ -f "${ROOT}"etc/mail/dk-filter/${selector}.private ]]; then
		ewarn "The private key for this selector already exists."
	else
		einfo "Select the size of private key:"
		einfo "  [1] 512 bits"
		einfo "  [2] 1024 bits"
		while read -n 1 -s -p "  Press 1 or 2 on the keyboard to select the key size " keysize ; do
			[[ "${keysize}" == "1" || "${keysize}" == "2" ]] && echo && break
		done
		case ${keysize} in
			1) keysize=512 ;;
			*) keysize=1024 ;;
		esac

		# generate the private and public keys
		openssl genrsa -out "${ROOT}"etc/mail/dk-filter/${selector}.private ${keysize} && \
			chown milter:milter "${ROOT}"etc/mail/dk-filter/${selector}.private && chmod u=r,g-rwx,o-rwx "${ROOT}"etc/mail/dk-filter/${selector}.private &&
			openssl rsa -in "${ROOT}"etc/mail/dk-filter/${selector}.private -out "${ROOT}"etc/mail/dk-filter/${selector}.public -pubout -outform PEM || \
				{ eerror "Failed to create private and public keys." ; return 1; }
	fi

	# dk-filter selector configuration
	echo
	einfo "Make sure you add these parameters to your dk-filter command line:"
	einfo "  -b sv -d your-domain.com -H -s /etc/mail/dk-filter/${selector}.private -S ${selector}"

	# MTA configuration
	echo
	einfo "If you are using Postfix, add following lines to your main.cf:"
	einfo "  smtpd_milters     = unix:/var/run/dk-filter/dk-filter.sock"
	einfo "  non_smtpd_milters = unix:/var/run/dk-filter/dk-filter.sock"

	# DNS configuration
	{
		local line
		pubkey=
		while read line; do
			[[ "${line}" == "--"* ]] || pubkey="${pubkey}${line}"
		done
	} < "${ROOT}"etc/mail/dk-filter/${selector}.public
	echo
	einfo "After you configured your MTA, publish your key by adding this TXT record to your domain:"
	einfo "  ${selector}._domainkey   IN   TXT  \"g=\\; k=rsa\\; t=y\\; o=~\\; p=${pubkey}\""
	echo
	einfo "t=y signifies you only test the DK on your domain."
	einfo "See the DomainKeys specification for more info."
}
