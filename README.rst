========================
OSSDL overlay for Gentoo
========================
:Author: Mark Kubacki <wmark+overlay@hurrikane.de> et al.
:source: http://github.com/wmark/ossdl-overlay

After using Gentoo for 13 years I have moved away.

I do believe that creating binaries in isolated environments, and then installing those binaries, is the most efficient way to go:
Without that kind of isolation not only your USE-flags and program versions influence the outcome of a *emerge* run.
Whatever is already installed on your system has a say, too.

For example, you cannot *emerge* a static *curl* but leaving (dynamic library) *libssl.so* on the system for other packages.
You would need to patch build scripts of *curl*, or temporarily removing *libssl.so* only keeping *libssl.a*.
And there are behemots like MonetDB which check for 8+ other dependencies, ignoring any *configure* flags.

I found it easier to run *Portage* in a docker container, from a minimal base system, for every package and its
dependencies I want to receive.
But for collecting those minimal builds I don't need Gentoo anymore.

Installation and Usage
======================
To install::

    mkdir -p /var/portage/overlays
    cd $_
    git clone [address-of-overlay] ossdl

    nano /etc/portage/make.conf || nano /etc/make.conf
    PORTDIR_OVERLAY="/var/portage/overlays/ossdl"

After the next ``emerge --sync`` or ``eix-sync -u`` the new packages should be available for search.

Packages
--------
Some packages are masked in Gentoo's main tree. If you want to unmask only the ones of this
overlay you can do so by adding to your ``/etc/portage/package.unmask``::

    dev-db/mariadb::OSSDL
    dev-libs/openssl::OSSDL
    net-misc/curl::OSSDL
    sys-devel/gcc::OSSDL
    www-servers/nginx::OSSDL

Optional
========

Binhost
-------

    The binhost is no longer open to the public, and for registered users only.

Find pre-compiled Gentoo packages here: (removed)

Obviously you will have to point Gentoo's *Portage* to these overlays. Modify your **make.conf** as follows::

    FEATURES="parallel-fetch getbinpkg"
    PORTAGE_BINHOST="https://binhost.ossdl.de/AMD64/Intel/corei7-avx/x86_64-pc-linux-gnu/"

-- Mark Kubacki, 2012-08-01, 2012-09-29, 2013-08-10
