# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit autotools db-use eutils flag-o-matic ssl-cert fixheadtails pam multilib

MY_P=${P/_/}

DESCRIPTION="The Cyrus IMAP Server."
HOMEPAGE="http://asg.web.cmu.edu/cyrus/imapd/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${MY_P}.tar.gz"
LIBWRAP_PATCH_VER="2.2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="idled kerberos kolab nntp pam replication +sieve snmp ssl tcpd fastmail -berkdb"

PROVIDE="virtual/imapd"
RDEPEND="berkdb? ( >=sys-libs/db-3.2 )
	>=dev-libs/cyrus-sasl-2.1.13
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	kerberos? ( virtual/krb5 )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	kolab? ( net-nds/openldap )
	nntp? ( !net-nntp/leafnode )"

DEPEND="$RDEPEND
	sys-devel/libtool
	>=sys-devel/autoconf-2.58
	sys-devel/automake"

RDEPEND="$RDEPEND
	!virtual/imapd"

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

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A} && cd "${S}"

	ht_fix_file "${S}"/imap/xversion.sh

	# Fix prestripped binaries
	epatch "${FILESDIR}/${PN}-strip.patch"

	epatch "${FILESDIR}/${P}-bug283596-2.patch"

	if use kolab ; then
		EPATCH_SOURCE="${FILESDIR}/kolab/${PV}" EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" epatch
		# These files are being created automatically and need to be updated
		# # after the patches used above
		rm -f lib/imapopts.h lib/imapopts.c
	fi

	# Add libwrap defines as we don't have a dynamicly linked library.
	use tcpd && epatch "${FILESDIR}/${PN}-${LIBWRAP_PATCH_VER}-libwrap.patch"

	# patches from fastmail.fm
	if use fastmail ; then
		if use berkdb ; then
			epatch "${FILESDIR}/cyrus-findall-txn-2.3.12.diff"
			epatch "${FILESDIR}/cyrus-folder-limit-2.3.12.diff"
		fi
		epatch "${FILESDIR}/cyrus-skiplist-tuning-2.3.10.diff"
		epatch "${FILESDIR}/cyrus-fromheader-2.3.3.diff"
		epatch "${FILESDIR}/cyrus-imapd-2.3.1-autoreply-0.1-0.diff"
		epatch "${FILESDIR}/cyrus-mailwasher-2.3.6.diff"
		epatch "${FILESDIR}/cyrus-receivedtime-2.3.8.diff"
		epatch "${FILESDIR}/cyrus-warnmismatchedguid-2.3.10.diff"
		epatch "${FILESDIR}/cyrus-digest-sha1-2.3.11.diff"
	fi


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

	# Remove unwanted m4 files
	rm "cmulocal/ax_path_bdb.m4" || die "Failed to remove cmulocal/ax_path_bdb.m4"

	# Add db-4.7 support
	epatch "${FILESDIR}/${P}-add-db47-support.patch"
	# Fix RPATH issues
	epatch "${FILESDIR}/${P}-fix-db-rpath.patch"

	# Recreate configure.
	WANT_AUTOCONF="2.5"
	AT_M4DIR="cmulocal" eautoreconf

	# When linking with rpm, you need to link with more libraries.
	sed -i -e "s:lrpm:lrpm -lrpmio -lrpmdb:" configure || die "sed failed"

	if use kolab ; then
		sed -i -e "s/{LIB_SASL}/{LIB_SASL} -lldap -llber /" configure || die
		"sed failed"
	fi
}

src_compile() {
	local myconf
	myconf="${myconf} $(use_with ssl openssl)"
	myconf="${myconf} $(use_with snmp ucdsnmp)"
	myconf="${myconf} $(use_with tcpd libwrap)"
	myconf="${myconf} $(use_enable kerberos gssapi) $(use_enable kerberos krb5afspts)"
	myconf="${myconf} $(use_enable idled)"
	myconf="${myconf} $(use_enable nntp)"
	myconf="${myconf} $(use_enable replication)"

	if use berkdb; then
		myconf="${myconf} --with-bdb=$(db_libname)"
		ewarn "Make sure you did upgrade berkeley-db files correctly or cyrus won't work."
	else
		myconf="${myconf} --with-bdb=no"
	fi

	if use kerberos; then
		myconf="${myconf} --with-krb=$(krb5-config --prefix) --with-krbdes=no"
	else
		myconf="${myconf} --with-krb=no"
	fi

	econf \
		--enable-murder \
		--enable-listext \
		--enable-netscapehack \
		--with-extraident=Hurrikane \
		--with-service-path=/usr/$(get_libdir)/cyrus \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--without-perl \
		${myconf} || die "econf failed"

	# needed for parallel make. Bug #72352.
	cd "${S}"/imap
	emake xversion.h || die "emake xversion.h failed"

	# -j1 for #222529
	cd "${S}"
	emake -j1 || die "compile problem"
}

src_install() {
	local SUBDIRS

	if use sieve; then
		SUBDIRS="master imap imtest timsieved notifyd sieve"
	else
		SUBDIRS="master imap imtest"
	fi

	dodir /usr/bin /usr/lib
	for subdir in ${SUBDIRS}; do
		make -C "${subdir}" DESTDIR="${D}" install || die "make install failed"
	done

	# Link master to cyrusmaster (postfix has a master too)
	dosym /usr/lib/cyrus/master /usr/lib/cyrus/cyrusmaster

	if ! use nntp ; then
		rm man/fetchnews.8 man/syncnews.8 man/nntpd.8 man/nntptest.1
		rm "${D}"/usr/bin/nntptest
	fi

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
	# do not install server.{key,pem) if they are exist.
	use ssl && {
		if [ ! -f "${ROOT}"etc/ssl/cyrus/server.key ]; then
			install_cert /etc/ssl/cyrus/server
			chown cyrus:mail "${ROOT}"etc/ssl/cyrus/server.{key,pem}
	fi
	}

	if df -T /var/imap | grep -q ' ext2 ' ; then
		ebegin "Making /var/imap/user/* and /var/imap/quota/* synchronous."
		chattr +S /var/imap/{user,quota}{,/*}
		eend $?
	fi

	if df -T /var/spool/imap | grep -q ' ext2 ' ; then
		ebegin "Making /var/spool/imap/* synchronous."
		chattr +S /var/spool/imap{,/*}
		eend $?
	fi

	ewarn "If the queue directory of the mail daemon resides on an ext2"
	ewarn "filesystem you need to set it manually to update"
	ewarn "synchronously. E.g. 'chattr +S /var/spool/mqueue'."
	echo

	elog "For correct logging add the following to /etc/syslog.conf:"
	elog "    local6.*         /var/log/imapd.log"
	elog "    auth.debug       /var/log/auth.log"
	echo

	elog "You have to add user cyrus to the sasldb2. Do this with:"
	elog "    saslpasswd2 cyrus"
}
