# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/apache/apache-2.2.0-r2.ebuild,v 1.4 2006/03/08 04:03:54 halcy0n Exp $

inherit eutils gnuconfig multilib

# latest gentoo apache files
GENTOO_PATCHNAME="gentoo-apache-${PVR}"
GENTOO_PATCHSTAMP="20060306"
GENTOO_DEVSPACE="hollow"
GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"

DESCRIPTION="The Apache Web Server"
HOMEPAGE="http://httpd.apache.org/"
SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2
	http://dev.gentoo.org/~${GENTOO_DEVSPACE}/dist/apache/${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2"

# some helper scripts are apache-1.1, thus both are here
LICENSE="Apache-2.0 Apache-1.1"

SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug doc ldap no-suexec ssl static-modules threads selinux mpm-prefork mpm-worker mpm-event mpm-peruser"

RDEPEND="dev-lang/perl
	>=dev-libs/apr-1.2.2
	>=dev-libs/apr-util-1.2.2
	dev-libs/expat
	app-misc/mime-types
	sys-libs/zlib
	ssl? ( dev-libs/openssl )
	selinux? ( sec-policy/selinux-apache )
	!mips? ( ldap? ( =net-nds/openldap-2* ) )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.59-r4"

S="${WORKDIR}/httpd-${PV}"



pkg_setup() {
	if use ldap && ! built_with_use 'dev-libs/apr-util' ldap; then
		eerror "dev-libs/apr-util is missing LDAP support. For apache to have"
		eerror "ldap support, apr-util must be built with the ldap USE-flag"
		eerror "enabled."
		die "ldap USE-flag enabled while not supported in apr-util"
	fi

	# select our MPM
	MPM_LIST="prefork worker event peruser"
	for x in ${MPM_LIST}; do
		if useq mpm-${x}; then
			if [ "x${mpm}" == "x" ]; then
				mpm=${x}
				einfo "Selected MPM: ${mpm}"
			else
				eerror "You have selected more then one mpm USE-flag."
				eerror "Only one MPM is supported."
				die "more then one mpm was specified"
			fi
		fi
	done

	if [ "x${mpm}" == "x" ]; then
		if useq "threads"; then
			mpm=worker
			einfo "Selected default threaded MPM: ${mpm}";
		else
			mpm=prefork
			einfo "Selected default MPM: ${mpm}";
		fi
	fi
}



src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	# Use correct multilib libdir in gentoo patches
	sed -i -e "s:/usr/lib:/usr/$(get_libdir):g" \
		${GENTOO_PATCHDIR}/{conf/httpd.conf,init/*,patches/config.layout} \
		|| die "sed failed"


	#### Patch Organization
	# 00-19 Gentoo specific  (00_all_some-title.patch)
	# 20-39 Additional MPMs  (20_all_${MPM}_some-title.patch)
	# 40-59 USE-flag based   (40_all_${USE}_some-title.patch)
	# 60-79 Version specific (60_all_${PV}_some-title.patch)
	# 80-99 Security patches (80_all_${PV}_cve-####-####.patch)

	EPATCH_SUFFIX="patch"
	epatch ${GENTOO_PATCHDIR}/patches/[0-1]* || die "Patching failed"
	if $(ls ${GENTOO_PATCHDIR}/patches/[2-3]?_*_${mpm}_* &>/dev/null); then
		epatch ${GENTOO_PATCHDIR}/patches/[2-3]?_*_${mpm}_* || \
		die "MPM ${mpm} Patching failed"
	fi
	for uf in ${IUSE}; do
		if useq ${uf} && $(ls ${GENTOO_PATCHDIR}/patches/[4-5]?_*_${uf}_* &>/dev/null)
		then
			epatch ${GENTOO_PATCHDIR}/patches/[4-5]?_*_${uf}_* || \
			die "USE=\"${uf}\" Patching failed"
		fi
	done
	if $(ls ${GENTOO_PATCHDIR}/patches/[6-9]?_*_${PV}_* &>/dev/null); then
		epatch ${GENTOO_PATCHDIR}/patches/[6-9]?_*_${PV}_* || \
		die "Version ${PV} Patching failed"
	fi


	# avoid utf-8 charset problems
	export LC_CTYPE=C

	# setup the filesystem layout config
	cat ${GENTOO_PATCHDIR}/patches/config.layout >> config.layout
	sed -i -e "s:version:${PF}:g" config.layout

	einfo "Rebuilding configure"
	# patched-in MPMs probably need this
	WANT_AUTOCONF=2.5 ./buildconf || die "buildconf failed"

}



src_compile() {

	# Detect mips and uclibc systems properly
	gnuconfig_update

	local modtype
	if useq static-modules; then
		modtype="static"
	else
		modtype="shared"
	fi

	select_modules_config || die "determining modules failed"

	local myconf
	useq ldap && mods="${mods} ldap authnz-ldap" && \
		myconf="${myconf} --enable-authnz-ldap=${modtype}" && \
		myconf="${myconf} --enable-ldap=${modtype}"
	useq ssl && mods="${mods} ssl" && \
		myconf="${myconf} --with-ssl=/usr  --enable-ssl=${modtype}"

	# Fix for bug #24215 - robbat2@gentoo.org, 30 Oct 2003
	# We pre-load the cache with the correct answer!  This avoids
	# it violating the sandbox.  This may have to be changed for
	# non-Linux systems or if sem_open changes on Linux.  This
	# hack is built around documentation in /usr/include/semaphore.h
	# and the glibc (pthread) source
#	echo 'ac_cv_func_sem_open=${ac_cv_func_sem_open=no}' >> ${S}/config.cache

	if useq no-suexec; then
		myconf="${myconf} --disable-suexec"
	else
		mods="${mods} suexec"
		myconf="${myconf} $(${GENTOO_PATCHDIR}/scripts/suexec2-config --config)"

		myconf="${myconf}
				--with-suexec-bin=/usr/sbin/suexec2 \
				--enable-suexec=${modtype}"
	fi

	# common confopts
	myconf="${myconf} \
			--cache-file=${S}/config.cache \
			--with-perl=/usr/bin/perl \
			--with-expat=/usr \
			--with-z=/usr \
			--with-port=80 \
			--enable-layout=Gentoo \
			--with-program-name=apache2 \
			--host=${CHOST} ${MY_BUILTINS}"
			#--with-apr=/usr \
			#--with-apr-util=/usr \

	# debugging support
	if useq debug ; then
		myconf="${myconf} --enable-maintainer-mode"
	fi

	./configure --with-mpm=${mpm} ${myconf} || die "bad ./configure please submit bug report to bugs.gentoo.org. Include your config.layout and config.log"

	# we don't want to try and recompile the ssl_expr_parse.c file, because
	# the lex source is broken
#	touch modules/ssl/ssl_expr_scan.c

	# as decided on IRC-AGENDA-10.2004, we use httpd.conf as standard config file name
	sed -i -e 's:apache2\.conf:httpd.conf:' include/ap_config_auto.h

	emake || die "problem compiling apache2"

	# build ssl version of apache bench (ab-ssl)
#	if useq ssl; then
#		cd support
#		rm -f ab .libs/ab ab.lo ab.o
#		make ab CFLAGS="${CFLAGS} -DUSE_SSL -lcrypto -lssl -I/usr/include/openssl -L/usr/$(get_libdir)" || die
#		mv ab ab-ssl
#		rm -f ab.lo ab.o
#		make ab || die
#	fi
}

src_install () {


	#### DEFAULT SETUP & INSTALL

	# setup apache user and group
	enewgroup apache 81
	enewuser apache 81 -1 /var/www apache

	# general install
	einfo "Beginning install phase"
	make DESTDIR=${D} install || die

	#### CLEAN-UP
	rm -rf ${D}/etc
	rm ${D}/usr/sbin/envvars*
	rm ${D}/usr/sbin/apachectl

	#### CONFIGURATION
	einfo "Setting up configuration"
	insinto /etc/apache2

	# restore the magic file
	doins docs/conf/magic


	# This is a mapping of module names to the -D option in APACHE2_OPTS
	# Used for creating optional LoadModule lines
	mod_defines="info:INFO status:INFO
				ldap:LDAP authnz-ldap:AUTH_LDAP
				proxy:PROXY proxy_connect:PROXY proxy_http:PROXY
				ssl:SSL
				suexec:SUEXEC
				userdir:USERDIR"

	# create our LoadModule lines
	if ! useq static-modules; then
	load_module=''
	moddir="${D}/usr/$(get_libdir)/apache2/modules"
	for m in ${mods}; do
		endid="no"

		if [ -e "${moddir}/mod_${m}.so" ]; then
			for def in ${mod_defines}; do
				if [ "${m}" == "${def%:*}" ]; then
					load_module="${load_module}\n<IfDefine ${def#*:}>"
					endid="yes"
				fi
			done
			load_module="${load_module}\nLoadModule ${m}_module modules/mod_${m}.so"
			if [ "${endid}" == "yes" ]; then
				load_module="${load_module}\n</IfDefine>"
			fi
		fi
	done
	fi
	sed -i -e "s:%%LOAD_MODULE%%:${load_module}:" \
		${GENTOO_PATCHDIR}/conf/httpd.conf || die "sed failed"

	# install our configuration	
	doins -r ${GENTOO_PATCHDIR}/conf/*

	insinto /etc/logrotate.d
	newins ${GENTOO_PATCHDIR}/scripts/apache2-logrotate apache2

	# generate a sane default APACHE2_OPTS
	APACHE2_OPTS="-D DEFAULT_VHOST -D INFO -D LANGUAGE"
	useq doc && APACHE2_OPTS="${APACHE2_OPTS} -D MANUAL"
	useq ssl && APACHE2_OPTS="${APACHE2_OPTS} -D SSL -D SSL_DEFAULT_VHOST"
	useq no-suexec || APACHE2_OPTS="${APACHE2_OPTS} -D SUEXEC"

	sed -i -e "s:APACHE2_OPTS=\".*\":APACHE2_OPTS=\"${APACHE2_OPTS}\":" \
		${GENTOO_PATCHDIR}/init/apache2.confd \
		|| die "sed failed"

	mv ${D}/etc/apache2/apache2-builtin-mods ${D}/etc/apache2/apache2-builtin-mods-2.2

	newconfd ${GENTOO_PATCHDIR}/init/apache2.confd apache2
	newinitd ${GENTOO_PATCHDIR}/init/apache2.initd apache2


	#### HELPER SCRIPTS
	einfo "Installing helper scripts"
	exeinto /usr/sbin
	for i in apache2logserverstatus apache2splitlogfile suexec2-config; do
		doexe ${GENTOO_PATCHDIR}/scripts/${i}
	done
	useq ssl && doexe ${GENTOO_PATCHDIR}/scripts/gentestcrt.sh

	for i in logresolve.pl split-logfile log_server_status; do
		doexe support/${i}
	done



	#### SLOTTING
	einfo "Applying SLOT=2"
	cd ${D}

	# sbin binaries
	slotmv="apxs htpasswd htdigest rotatelogs logresolve log_server_status
			ab checkgid dbmmanage split-logfile suexec"
	for i in ${slotmv}; do
		mv usr/sbin/${i} usr/sbin/${i}2
	done
	mv usr/sbin/logresolve.pl usr/sbin/logresolve2.pl

	# man.1
	for i in dbmmanage htdigest htpasswd; do
		mv usr/share/man/man1/${i}.1 usr/share/man/man1/${i}2.1
	done

	# man.8
	for i in ab apxs logresolve rotatelogs suexec; do
		mv usr/share/man/man8/${i}.8 usr/share/man/man8/${i}2.8
	done

	mv usr/share/man/man8/httpd.8 usr/share/man/man8/apache2.8
	mv usr/share/man/man8/apachectl.8 usr/share/man/man8/apache2ctl.8



	#### DOCS
	# basic info
	einfo "Installing docs"
	cd ${S}
	dodoc ABOUT_APACHE CHANGES LAYOUT README README.platforms VERSIONING

	# drop in a convenient link to the manual
	if useq doc; then
		sed -i -e "s:VERSION:${PVR}:" ${D}/etc/apache2/modules.d/00_apache_manual.conf
	else
		einfo "USE=-docs :: Removing Manual"
		rm ${D}/etc/apache2/modules.d/00_apache_manual.conf
		rm -rf ${D}/usr/share/doc/${PF}/manual
	fi

	# the default webroot gets stored in /usr/share/doc
	einfo "Installing default webroot to /usr/share/doc/${PF}"
	mv ${D}/var/www/localhost ${D}/usr/share/doc/${PF}/webroot


	#### PERMISSONS
	einfo "Applying permissions"


	# protect the suexec binary
	if ! useq no-suexec; then
		fowners root:apache /usr/sbin/suexec2
		fperms 4710 /usr/sbin/suexec2
	fi

	keepdir /etc/apache2/vhosts.d
	keepdir /etc/apache2/modules.d

	# empty dirs
	for i in /var/lib/dav /var/log/apache2 /var/cache/apache2; do
		keepdir ${i}
		fowners apache:apache ${i}
		fperms 755 ${i}
	done

	# We'll be needing /etc/apache2/ssl if USE=ssl
	useq ssl && keepdir /etc/apache2/ssl

	fperms 755 /usr/sbin/apache2logserverstatus
	fperms 755 /usr/sbin/apache2splitlogfile

}

pkg_postinst() {
	# setup apache user and group
	enewgroup apache 81
	enewuser apache 81 -1 /var/www apache

	# Automatically generate test ceritificates if ssl USE flag is being set
	if useq ssl -a !-e ${ROOT}/etc/apache2/ssl/server.crt; then
		cd ${ROOT}/etc/apache2/ssl
		einfo
		einfo "Generating self-signed test certificate in /etc/apache2/ssl..."
		yes "" 2>/dev/null | \
			${ROOT}/usr/sbin/gentestcrt.sh >/dev/null 2>&1 || \
			die "gentestcrt.sh failed"
		einfo
	fi

	# we do this here because the default webroot is a copy of the files
	# that exist elsewhere and we don't want them managed/removed by portage
	# when apache is upgraded.
	if [ -e "/var/www/localhost" ]; then
		einfo "The default webroot has not been installed into"
		einfo "/var/www/localhost because the directory already exists"
		einfo "and we do not want to overwrite any files you have put there."
		einfo
		einfo "If you would like to install the latest webroot, please run"
		einfo "emerge --config =${PF}"
	else
		einfo "Installing default webroot to /var/www/localhost"
		cp -r /usr/share/doc/${PF}/webroot/* /var/www/localhost
		chown -R apache: /var/www/localhost
	fi

	# Check for dual/upgrade install
	# The hasq is a hack so we don't throw QA warnings for not putting
	# apache2 in IUSE - the only use of the flag is this warning
	if has_version '=net-www/apache-1*' || ! hasq apache2 ${USE}; then
		ewarn
		ewarn "Please add the 'apache2' flag to your USE variable and (re)install"
		ewarn "any additional DSO modules you may wish to use with Apache-2.x."
		ewarn "Addon modules are configured in /etc/apache2/modules.d/"
		ewarn
	fi


	if has_version '<net-www/apache-2.2.0'; then
		einfo
		einfo "When upgrading from versions below 2.2.0 to this version, you"
		einfo "need to rebuild all your modules. Please do so for your modules"
		einfo "to continue working correctly."
		einfo
		einfo "Also note that some configuration directives have been"
		einfo "split into thier own files under /etc/apache2/modules.d"
		einfo
		einfo "For more information on what you may need to change, please"
		einfo "see the overview of changes at:"
		einfo "http://httpd.apache.org/docs/2.2/new_features_2_2.html"
		einfo
	fi

}


pkg_config() {

	einfo "Installing default webroot to /var/www/localhost"
	cp -r /usr/share/doc/${PF}/webroot/* /var/www/localhost
	chown -R apache: /var/www/localhost

}





parse_modules_config() {
	local name=""
	local disable=""
	local version="undef"
	MY_BUILTINS=""
	mods=""
	[ -f "${1}" ] || return 1

	for i in $(sed 's/#.*//' < $1); do

		if [ "$i" == "VERSION:" ]; then
			version="select"
		elif [ "${version}" == "select" ]; then
			version=$i
		# start with - option for backwards compatibility only
		elif [ "$i" == "-" ]; then
			disable="true"
		elif [ -z "${name}" ] && [ "$i" != "${i/mod_/}" ]; then
			name="${i/mod_/}"
		elif [ -n "${disable}" ] || [ "$i" == "disabled" ]; then
			MY_BUILTINS="${MY_BUILTINS} --disable-${name}"
			name="" ; disable=""
		elif [ "$i" == "static" ] || useq static-modules; then
			MY_BUILTINS="${MY_BUILTINS} --enable-${name}=yes"
			name="" ; disable=""
		elif [ "$i" == "shared" ]; then
			MY_BUILTINS="${MY_BUILTINS} --enable-${name}=shared"
			mods="${mods} ${name}"
			name="" ; disable=""
		else
			ewarn "Parse error in ${1} - unknown option: $i";
		fi
	done

	# reject the file if it's unversioned or doesn't match our
	# package major.minor. This is to make upgrading work smoothly.
	if [ "${version}" != "${PV%.*}" ]; then
		mods=""
		MY_BUILTINS=""
		return 1
	fi

	einfo "Using ${1}"
	einfo "options: ${MY_BUILTINS}"
	einfo "LoadModules: ${mods}"
}

select_modules_config() {
	parse_modules_config /etc/apache2/apache2-builtin-mods-2.2 || \
	parse_modules_config ${GENTOO_PATCHDIR}/conf/apache2-builtin-mods || \
	return 1
}

# vim:ts=4
