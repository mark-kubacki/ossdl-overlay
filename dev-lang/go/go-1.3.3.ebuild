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
	TOOLS_PV="1b06ca8030a3"
	SRC_URI="https://storage.googleapis.com/golang/go${PV/_/}.src.tar.gz
		https://binhost.ossdl.de/distfiles/go.tools-${TOOLS_PV}.tar.xz"
	# Upstream only supports go on amd64, arm and x86 architectures.
	KEYWORDS="-* amd64 arm x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
fi

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="http://www.golang.org"
RESTRICT="primaryuri"

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
	epatch "${FILESDIR}"/go-1.3.0-net-implement-TCP-fast-open.patch
	epatch "${FILESDIR}"/go-1.3.0-net-improve-behavior-of-native-Go-DNS-queries.patch
	epatch "${FILESDIR}"/go-1.3.0-net-mail-Decode-RFC2047-encoded-headers.patch
	epatch "${FILESDIR}"/go-1.3.0-TLS-add-SHA256-cipher-suites.patch
	epatch "${FILESDIR}"/go-1.3-TLS_support_SHA384.patch
	epatch "${FILESDIR}"/go-1.3.2-crypto-rand-use-getrandom-system-call-on-Linux.patch
	epatch "${FILESDIR}"/go-1.3-syscall-fix-infinite-recursion-in-itoa.patch
	epatch "${FILESDIR}"/go-1.3-make-build_-a_skip-standard-packages-in-Go-releases.patch
	epatch "${FILESDIR}"/go-1.3-crypto-add-SHA3-functions-to-Hash-enum.patch

	if [[ ${PV} != 9999 ]]; then
		epatch "${FILESDIR}"/${PN}-1.2-no-Werror.patch
	fi
	epatch_user

	# copy go.tools to a directory which Go will recognize
	if [ -d "${WORKDIR}"/go.tools ]; then
		ebegin "Copy go.tools to scratch directory"
		mkdir -p "${T}"/src/code.google.com/p
		cp -ra "${WORKDIR}"/go.tools "${T}"/src/code.google.com/p/
	fi
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

	ebegin "Compiling some go.tools"
	# the tools are listed in go/misc/makerelease/makerelease.go: toolPaths
	# not listed there and optional: goimports godex
	PATH="${GOBIN}:${PATH}" \
	GOPATH="${T}" \
	GOROOT="${EPREFIX}$(${GOBIN}/go env GOROOT)" \
	GOTOOLDIR="${EPREFIX}$(${GOBIN}/go env GOTOOLDIR)" \
		go install -v \
			code.google.com/p/go.tools/cmd/cover \
			code.google.com/p/go.tools/cmd/godoc \
			code.google.com/p/go.tools/cmd/vet \
			code.google.com/p/go.tools/cmd/goimports \
			code.google.com/p/go.tools/cmd/godex \
		|| die "cannot install go.tools"

	ebegin 'go.tools: rewriting "package main" to "package documentation"'
	# see go/misc/makerelease/makerelease.go: tools()
	for CMD in cover godoc vet goimports godex; do
		sed -i -e 's:^package main$:package documentation:' \
			"${T}"/src/code.google.com/p/go.tools/cmd/${CMD}/doc.go
	done
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

	# see go/misc/makerelease/makerelease.go: tools()
	for CMD in cover godoc vet goimports godex; do
		dodir /usr/lib/go/src/cmd/${CMD}
		insinto /usr/lib/go/src/cmd/${CMD}
		doins "${T}"/src/code.google.com/p/go.tools/cmd/${CMD}/doc.go
	done

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
