# Copyright 1999-2013 Gentoo Foundation
# Copyright 2013-2014 Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI=5

export CTARGET=${CTARGET:-${CHOST}}

inherit bash-completion-r1 elisp-common eutils

if [[ ${PV} = 9999 ]]; then
	EHG_REPO_URI="https://go.googlecode.com/hg"
	inherit mercurial
else
	SRC_URI="http://go.googlecode.com/files/go${PV}.src.tar.gz"
	# Upstream only supports go on amd64, arm and x86 architectures.
	KEYWORDS="-* amd64 arm x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
fi

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="http://www.golang.org"

LICENSE="BSD"
SLOT="0"
IUSE="bash-completion emacs vim-syntax zsh-completion"

DEPEND=""
RDEPEND="bash-completion? ( app-shells/bash-completion )
	emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	zsh-completion? ( app-shells/zsh-completion )"

# The tools in /usr/lib/go should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped.
STRIP_MASK="/usr/lib/go/pkg/linux*/*.a /usr/lib/go/pkg/freebsd*/*.a"

if [[ ${PV} != 9999 ]]; then
	S="${WORKDIR}"/go
fi

src_prepare()
{
	epatch "${FILESDIR}"/go-1.2-json_speedup-issue13894045_107001.patch
	epatch "${FILESDIR}"/go-1.2-more-efficient-byte-arrays-issue15930045_40001.patch
	epatch "${FILESDIR}"/go-1.2-TCP_fastopen-issue27150044_2060001.patch
	epatch "${FILESDIR}"/go-1.2-SHA256_assembly_for_amd64-issue28460043_80001.patch
	epatch "${FILESDIR}"/go-1.2-SHA_use_copy-issue35840044_140001.patch
	epatch "${FILESDIR}"/go-1.2-ASN1_non_printable_strings-issue22460043_50001.patch
	epatch "${FILESDIR}"/go-1.2-set_default_signature_hash_to_SHA256-issue40720047_100001.patch
	epatch "${FILESDIR}"/go-1.2-x509_import_SHA256-issue44010047_120001.patch
	epatch "${FILESDIR}"/go-1.2-syncpool-issue41860043_250001.patch
	epatch "${FILESDIR}"/go-1.2-http_use_syncpool-issue44080043_10002.patch

	# this one contains "copy from" and "copy to" which some version of patch don't understand
	sed \
		-e 's:crypto/sha256/sha256block:crypto/sha512/sha512block:g' \
		"${FILESDIR}"/go-1.2-SHA512_assembly_for_amd64-issue37150044_100001.patch \
		> go-1.2-SHA512_assembly_for_amd64.patch
	cp src/pkg/crypto/sha256/sha256block_amd64.s src/pkg/crypto/sha512/sha512block_amd64.s
	cp src/pkg/crypto/sha256/sha256block_decl.go src/pkg/crypto/sha512/sha512block_decl.go
	epatch go-1.2-SHA512_assembly_for_amd64.patch

	epatch "${FILESDIR}"/go-1.2-RSA_support_unpadded_signatures-issue44400043_80001.diff.patch
	epatch "${FILESDIR}"/go-1.2-use_TCP_keepalive-issue48300043_80001.patch
	epatch "${FILESDIR}"/go-1.2-TLS_support_renegotiation_extension-issue48580043_80001.patch
	epatch "${FILESDIR}"/go-1.2-speed_up_xop_ops-issue24250044_160001.patch
	epatch "${FILESDIR}"/go-1.2-improved_cbc_performance-issue50900043_200001.patch

	# go 1.2.1
#	epatch "${FILESDIR}"/go-1.2.1-fix-specials-deadlock-issue53120043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-per-P-defer-pool-issue42750044_80001.patch
	epatch "${FILESDIR}"/go-1.2.1-delete-proc-p-issue43500045_60001.patch
#	epatch "${FILESDIR}"/go-1.2.1-do-not-collect-GC-roots-explicitly-issue46860043_190005.patch
	epatch "${FILESDIR}"/go-1.2.1-syscall-use-unsafe.Pointer-issue55410043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-allocate-goroutine-ids-in-batches-issue46970043_100001.patch
#	epatch "${FILESDIR}"/go-1.2.1-remove-locks-from-netpoll-hotpaths-issue45700043_240001.patch
#	epatch "${FILESDIR}"/go-1.2.1-fix-buffer-overflow-in-stringtoslicerune-issue54760045_90001.patch
	epatch "${FILESDIR}"/go-1.2.1-include-MOVQL-opcode-issue54660046_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-fix-incorrect-Stack-output-issue57330043_70001.patch
	epatch "${FILESDIR}"/go-1.2.1-pass-a-files-in-order-issue28050043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-fix-buffer-overflow-in-make-chan-issue50250045_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-ASN1-support-tag-when-unmarshalling-issue56700043_80001.patch
	epatch "${FILESDIR}"/go-1.2.1-fix-incoming-connections-network-name-issue57520043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-encoding-fix-two-crashes-on-corrupted-data-issue56870043_70001.patch
	epatch "${FILESDIR}"/go-1.2.1-correctly-handle-timezone-issue58450043_120001.patch
	epatch "${FILESDIR}"/go-1.2.1-TLS-do-not-send-current-time-in-hello-issue57230043_50001.patch
	epatch "${FILESDIR}"/go-1.2.1-math-big-replace-goto-with-for-loop-issue55470046_30001.patch
	epatch "${FILESDIR}"/go-1.2.1-do-not-create-world-writable-files-issue60480045_90001.patch
#	epatch "${FILESDIR}"/go-1.2.1-faster-memclr-on-x86-issue60090044_120001.patch
#	epatch "${FILESDIR}"/go-1.2.1-better-error-messages-for-if-switch-for-issue56770045_60001.patch
#	epatch "${FILESDIR}"/go-1.2.1-TLS-better-error-messages-issue60580046_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-crypt-subtle-panic-on-slice-length-mismatch-issue62190043_50001.patch
	epatch "${FILESDIR}"/go-1.2.1-X509-add-CSR-support-issue49830048_70001.patch
	epatch "${FILESDIR}"/go-1.2.1-TLS-enforce-ServerName-or-InsecureSkipVerify-be-given-issue67010043_80001.patch
	epatch "${FILESDIR}"/go-1.2.1-use-monotonic-clock-for-timer-values-issue53010043_180001.patch
#	epatch "${FILESDIR}"/go-1.2.1-fix-potential-memory-corruption-issue67990043_50001.patch
#	epatch "${FILESDIR}"/go-1.2.1-fix-heap-memory-corruption-issue67980043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-TLS-pick-ECDHE-curves-based-on-server-preference-issue66060043_110001.patch
	epatch "${FILESDIR}"/go-1.2.1-TLS-report-version-in-ConnectionState-issue68250043_60001.patch
	epatch "${FILESDIR}"/go-1.2.1-responseAndError-satisfies-the-net.Error-interface-issue55470048_30003.patch
###	epatch "${FILESDIR}"/go-1.2.1-add-Dialer.KeepAlive-issue68380043_70001.patch
	epatch "${FILESDIR}"/go-1.2.1b-add-Dialer.KeepAlive-after-FASTOPEN-issue68380043_70001.patch
	epatch "${FILESDIR}"/go-1.2.1-use-TCP-Keep-Alives-on-DefaultTransports-connections-issue68330046_2.patch
	epatch "${FILESDIR}"/go-1.2.1-add-TLSHandshakeTimeout-issue68150045_100001.patch
#	epatch "${FILESDIR}"/go-1.2.1-Transport.CancelRequest-for-requests-blocked-in-a-dial-issue69280043_80001.patch
	epatch "${FILESDIR}"/go-1.2.1-Server.ConnState-callback-issue69260044_90001.patch
	epatch "${FILESDIR}"/go-1.2.1-TLS-add-DialWithDialer-issue68920045_90001.patch
	epatch "${FILESDIR}"/go-1.2.1-add-Server.SetKeepAlivesEnabled-issue69670043_100001.patch
	epatch "${FILESDIR}"/go-1.2.1-fix-possible-race-in-Server.ConnState-issue70410044_120001.patch
	epatch "${FILESDIR}"/go-1.2.1-add-Client.Timeout-for-end-to-end-timeouts-issue70120045_120001.patch
#	epatch "${FILESDIR}"/go-1.2.1-TLS-split-connErr-to-avoid-read-write-races-issue69090044_130001.patch
	epatch "${FILESDIR}"/go-1.2.1-fix-location-of-StateHijacked-and-StateActive-issue69860049_110001.patch
	epatch "${FILESDIR}"/go-1.2.1-SMTP-set-ServerName-in-StartTLS-issue70380043_260001.patch

	epatch "${FILESDIR}"/go-1.2.1-fix-empty-string-handling-in-garbage-collector-issue74250043_80001.patch

	epatch "${FILESDIR}"/go-1.3.0-TLS-add-SHA256-cipher-suites.patch

	if [[ ${PV} != 9999 ]]; then
		epatch "${FILESDIR}"/${PN}-1.2-no-Werror.patch
	fi
	epatch_user
}

src_compile()
{
	export GOROOT_FINAL="${EPREFIX}"/usr/lib/go
	export GOROOT="$(pwd)"
	export GOBIN="${GOROOT}/bin"
	if [[ $CTARGET = armv5* ]]
	then
		export GOARM=5
	fi

	cd src
	./make.bash || die "build failed"
	cd ..

	if use emacs; then
		elisp-compile misc/emacs/*.el
	fi
}

src_test()
{
	cd src
	PATH="${GOBIN}:${PATH}" \
		./run.bash --no-rebuild --banner || die "tests failed"
}

src_install()
{
	dobin bin/*
	dodoc AUTHORS CONTRIBUTORS PATENTS README

	dodir /usr/lib/go
	insinto /usr/lib/go

	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# [1] http://code.google.com/p/go/issues/detail?id=2775
	doins -r doc include lib pkg src

	if use bash-completion; then
		dobashcomp misc/bash/go
	fi

	if use emacs; then
		elisp-install ${PN} misc/emacs/*.el misc/emacs/*.elc
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles
		doins -r misc/vim/ftdetect
		doins -r misc/vim/ftplugin
		doins -r misc/vim/syntax
		doins -r misc/vim/plugin
		doins -r misc/vim/indent
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/zsh/go
	fi

	fperms -R +x /usr/lib/go/pkg/tool
}

pkg_postinst()
{
	if use emacs; then
		elisp-site-regen
	fi

	# If the go tool sees a package file timestamped older than a dependancy it
	# will rebuild that file.  So, in order to stop go from rebuilding lots of
	# packages for every build we need to fix the timestamps.  The compiler and
	# linker are also checked - so we need to fix them too.
	ebegin "fixing timestamps to avoid unnecessary rebuilds"
	tref="usr/lib/go/pkg/*/runtime.a"
	find "${EROOT}"usr/lib/go -type f \
		-exec touch -r "${EROOT}"${tref} {} \;
	eend $?

	if [[ ${PV} != 9999 && -n ${REPLACING_VERSIONS} &&
		${REPLACING_VERSIONS} != ${PV} ]]; then
		elog "Release notes are located at http://golang.org/doc/go${PV}"
	fi
}

pkg_postrm()
{
	if use emacs; then
		elisp-site-regen
	fi
}
