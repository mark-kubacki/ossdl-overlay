# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cyrus-imapd/cyrus-imapd-2.3.7.ebuild,v 1.3 2007/01/08 15:31:33 flameeyes Exp $

inherit eutils ssl-cert fixheadtails pam

DESCRIPTION="The Cyrus IMAP Server."
HOMEPAGE="http://asg.web.cmu.edu/cyrus/imapd/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz
	mirror://gentoo/${PN}-2.3.7-uoa.tbz2"
LIBWRAP_PATCH_VER="2.2.10"
DRAC_PATCH_VER="2.3.7"
AUTOCREATE_PATCH_VER="2.3.7"
AUTOSIEVE_PATCH_VER="2.3.7"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc ~hppa ~ppc64"
IUSE="afs autocreate autosieve drac idled kerberos nntp pam snmp ssl tcpd"

PROVIDE="virtual/imapd"
RDEPEND=">=sys-libs/db-3.2
	>=dev-libs/cyrus-sasl-2.1.13
	afs? ( >=net-fs/openafs-1.2.2 )
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	kerberos? ( virtual/krb5 )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	drac? ( >=mail-client/drac-1.12-r1 )"

DEPEND="$RDEPEND
	sys-devel/libtool
	>=sys-devel/autoconf-2.58
	sys-devel/automake"

new_net-snmp_check() {
	# tcpd USE flag check. Bug #68254.
	if use tcpd ; then
		if has_version net-analyzer/net-snmp && ! built_with_use net-analyzer/net-snmp tcpd ; then
			eerror "You are emerging this package with USE=\"tcpd\""
			eerror "but \"net-analyzer/net-snmp\" has been emerged with USE=\"-tcpd\""
			fail_msg
		fi
	else
		if has_version net-analyzer/net-snmp && built_with_use net-analyzer/net-snmp tcpd ; then
			eerror "You are emerging this package with USE=\"-tcpd\""
			eerror "but \"net-analyzer/net-snmp\" has been emerged with USE=\"tcpd\""
			fail_msg
		fi
	fi
	# DynaLoader check. Bug #67411 

	if [ -x "$(type -p net-snmp-config)" ]; then
		einfo "$(type -p net-snmp-config) is found and executable."
		NSC_AGENTLIBS="$(net-snmp-config --agent-libs)"
		einfo "NSC_AGENTLIBS=\""${NSC_AGENTLIBS}"\""
		if [ -z "$NSC_AGENTLIBS" ]; then
			eerror "NSC_AGENTLIBS is null"
			einfo "please report this to bugs.gentoo.org"
		fi
		for i in ${NSC_AGENTLIBS}; do
			# check for the DynaLoader path.
			if [ "$(expr "$i" : '.*\(DynaLoader\)')" == "DynaLoader" ] ; then
				DYNALOADER_PATH="$i"
				einfo "DYNALOADER_PATH=\""${DYNALOADER_PATH}"\""
				if [[ ! -f "${DYNALOADER_PATH}" ]]; then
					eerror "\""${DYNALOADER_PATH}"\" is not found."
					einfo "Have you upgraded \"perl\" after"
					einfo "you emerged \"net-snmp\". Please re-emerge"
					einfo "\"net-snmp\" then try again. Bug #67411."
					die "\""${DYNALOADER_PATH}"\" is not found."
				fi
			fi
		done
	else
		eerror "\"net-snmp-config\" not found or not executable!"
		die "You have \"net-snmp\" installed but \"net-snmp-config\" is not found or not executable. Please re-emerge \"net-snmp\" and try again!"
	fi
}

fail_msg() {
	eerror "enable "snmp" USE flag for this package requires"
	eerror "that net-analyzer/net-snmp and this package both build with"
	eerror "\"tcpd\" or \"-tcpd\". Bug #68254"
	die "sanity check failed."
}

pkg_setup() {
	use snmp && new_net-snmp_check
	enewuser cyrus -1 -1 /usr/cyrus mail
}


src_unpack() {
	unpack ${A} && cd "${S}"

	ht_fix_file ${S}/imap/xversion.sh

	# Add unsupported patch wrt #18706 and #80630
	# fixed upstream.
	# use unsupported_8bit && epatch "${FILESDIR}/${PN}-${MY_8BIT_PATCH_VER}-unsupported-8bit.patch"

	# Unsupported UoA patch. Bug #112912 .
	# http://email.uoa.gr/projects/cyrus/autocreate/
	if use autocreate ; then
		epatch "${WORKDIR}/${PN}-${AUTOCREATE_PATCH_VER}-autocreate.patch"
		use drac && epatch "${FILESDIR}/${PN}-${DRAC_PATCH_VER}-drac_with_autocreate.patch"
	else
		use drac && epatch "${FILESDIR}/${PN}-${DRAC_PATCH_VER}-drac.patch"
	fi

	# Unsupported UoA patch. Bug #133187 .
	# http://email.uoa.gr/projects/cyrus/autosievefolder/
	use autosieve && epatch "${WORKDIR}/${PN}-${AUTOSIEVE_PATCH_VER}-autosieve.patch"

	# fix undefine symbols.
	use afs && epatch "${FILESDIR}/cyrus-imapd-2.3.6-afs.patch"

	# Add libwrap defines as we don't have a dynamicly linked library.
	use tcpd && epatch "${FILESDIR}/${PN}-${LIBWRAP_PATCH_VER}-libwrap.patch"

	# Fix master(8)->cyrusmaster(8) manpage.
	for i in `grep -rl -e 'master\.8' -e 'master(8)' "${S}"` ; do
		sed -i -e 's:master\.8:cyrusmaster.8:g' \
			-e 's:master(8):cyrusmaster(8):g' \
			"${i}" || die "sed failed" || die "sed failed"
	done
	mv man/master.8 man/cyrusmaster.8 || die "mv failed"
	sed -i -e "s:MASTER:CYRUSMASTER:g" \
		-e "s:Master:Cyrusmaster:g" \
		-e "s:master:cyrusmaster:g" \
		man/cyrusmaster.8 || die "sed failed"

	# Recreate configure.
	export WANT_AUTOCONF="2.5"
	rm -rf configure config.h.in autom4te.cache || die
	ebegin "Recreating configure"
	sh SMakefile &>/dev/null || die "SMakefile failed"
	eend $?

	# When linking with rpm, you need to link with more libraries.
	sed -i -e "s:lrpm:lrpm -lrpmio -lrpmdb:" configure || die "sed failed"
}

src_compile() {
	local myconf
	use afs && myconf="${myconf} -with-afs=/usr"
	myconf="${myconf} $(use_with drac)"
	myconf="${myconf} $(use_with ssl openssl)"
	myconf="${myconf} $(use_with snmp ucdsnmp)"
	myconf="${myconf} $(use_with tcpd libwrap)"
	myconf="${myconf} $(use_enable kerberos gssapi) $(use_enable kerberos krb5afspts)"
	myconf="${myconf} $(use_enable idled)"
	myconf="${myconf} $(use_enable nntp)"

	if use kerberos; then
		myconf="${myconf} --with-auth=krb5"
	else
		myconf="${myconf} --with-auth=unix"
	fi

	econf \
		--enable-murder \
		--enable-listext \
		--enable-netscapehack \
		--with-extraident=Hurrikane \
		--with-service-path=/usr/lib/cyrus \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--without-perl \
		--disable-cyradm \
		${myconf} || die "econf failed"

	# needed for parallel make. Bug #72352.
	cd ${S}/imap
	emake xversion.h || die "emake xversion.h failed"

	cd ${S}
	emake || die "compile problem"
}

src_install() {
	dodir /usr/bin /usr/lib
	for subdir in master imap imtest timsieved notifyd sieve; do
		make -C "${subdir}" DESTDIR="${D}" install || die "make install failed"
	done

	# Link master to cyrusmaster (postfix has a master too)
	dosym /usr/lib/cyrus/master /usr/lib/cyrus/cyrusmaster

	doman man/*.[0-8]
	dodoc COPYRIGHT README*
	dohtml doc/*.html doc/murder.png
	cp doc/cyrusv2.mc "${D}/usr/share/doc/${PF}/html"
	cp -r contrib tools "${D}/usr/share/doc/${PF}"
	find "${D}/usr/share/doc" -name CVS -print0 | xargs -0 rm -rf

	insinto /etc
	doins "${FILESDIR}/cyrus.conf" "${FILESDIR}/imapd.conf"

	newinitd "${FILESDIR}/cyrus.rc6" cyrus
	newconfd "${FILESDIR}/cyrus.confd" cyrus
	newpamd "${FILESDIR}/cyrus.pam-include" sieve

	# do not install server.{key,pem) if they are exist.
	if use ssl && [[ ! -f /etc/ssl/cyrus/server.key && ! -f /etc/ssl/cyrus/server.pem ]] ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Cyrus IMAP Server}"
		insinto /etc/ssl/cyrus
		docert server
		fowners cyrus:mail /etc/ssl/cyrus/server.{key,pem}
	fi

	for subdir in imap/{,db,log,msg,proc,socket,sieve} spool/imap/{,stage.} ; do
		keepdir "/var/${subdir}"
		fowners cyrus:mail "/var/${subdir}"
		fperms 0750 "/var/${subdir}"
	done
	for subdir in imap/{user,quota,sieve} spool/imap ; do
		for i in a b c d e f g h i j k l m n o p q r s t v u w x y z ; do
			keepdir "/var/${subdir}/${i}"
			fowners cyrus:mail "/var/${subdir}/${i}"
			fperms 0750 "/var/${subdir}/${i}"
		done
	done
}

pkg_postinst() {

	enewuser cyrus -1 -1 /usr/cyrus mail

	if df -T /var/imap | grep -q ' ext[23] ' ; then
		ebegin "Making /var/imap/user/* and /var/imap/quota/* synchronous."
		chattr +S /var/imap/{user,quota}{,/*}
		eend $?
	fi

	if df -T /var/spool/imap | grep -q ' ext[23] ' ; then
		ebegin "Making /var/spool/imap/* synchronous."
		chattr +S /var/spool/imap{,/*}
		eend $?
	fi

	ewarn "If the queue directory of the mail daemon resides on an ext2"
	ewarn "or ext3 filesystem you need to set it manually to update"
	ewarn "synchronously. E.g. 'chattr +S /var/spool/mqueue'."
	echo

	elog "For correct logging add the following to /etc/syslog.conf:"
	elog "    local6.*         /var/log/imapd.log"
	elog "    auth.debug       /var/log/auth.log"
	echo

	elog "You have to add user cyrus to the sasldb2. Do this with:"
	elog "    saslpasswd2 cyrus"
}
