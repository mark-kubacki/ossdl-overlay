# Copyright 2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=4
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="*-jython 3.*"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="cloudfiles"

inherit git-2 distutils eutils

DESCRIPTION="Python language bindings for Cloud Files API"
HOMEPAGE="https://github.com/rackspace/python-cloudfiles"
EGIT_REPO_URI="http://github.com/rackspace/python-cloudfiles.git"
EGIT_COMMIT="c182793f023e9cd204f25ba8e3ae21a2d5377051"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.7.11-bypass-cdn.diff"
	epatch "${FILESDIR}/${PN}-1.7.11-byte-count-on-callbacks.diff"
	epatch "${FILESDIR}/${PN}-1.7.11-fix-COPY.diff"
	epatch "${FILESDIR}/${PN}-1.7.11-https-autodiscovery-connect.diff"
	epatch "${FILESDIR}/${PN}-1.7.11-TCP-keep-alive-mod.diff"
}