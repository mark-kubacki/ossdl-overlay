# Copyright 2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI=4
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="*-jython 3.*"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="cloudfiles"

inherit git-2 distutils

DESCRIPTION="Python language bindings for Cloud Files API"
HOMEPAGE="https://github.com/rackspace/python-cloudfiles"
EGIT_REPO_URI="http://github.com/rackspace/python-cloudfiles.git"
EGIT_COMMIT="${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""
