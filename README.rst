========================
OSSDL overlay for Gentoo
========================
:Author: Mark Kubacki <wmark+overlay@hurrikane.de> et al.
:source: http://github.com/wmark/ossdl-overlay
:mirror: https://bitbucket.org/wmark/ossdl-overlay

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
Some packages are masked in Gentoo's main tree. If you want to unmask only the tested ones of this
overlay you can do so by adding to your ``/etc/portage/package.unmask``::

    # category/package::overlay-name
    
    www-servers/apache::OSSDL
    app-admin/apache-tools::OSSDL

Policies
--------

If a package has been "keyworded" by the Gentoo devs and I don't encounter any errors and find it 
stable/sufficient enough for production use then the keyword is stripped in this overlay (thus 
marking the package as 'stable'). That tests are limited to the following systems/architectures:

- Intel — 3rd generation Core/Xeons
- ARM — Cortex-A15 multicore server

If you want to include an ebuild into this overlay then please fork it, add your ebuild, and finally
email me the link. Whenever I write 'me' in this README indeed 'us' is meant. ;-)
You can get commit-access to this git repository if you're willing to keep that package up-to-date.

You — and that includes Gentoo developers — are not allowed to strip any Copyright lines. Whenever
you add something non-trivial just add your name to any existing list with a matching year, or to
a separate line should such list not already exist.

Remove SVN keyword lines such as: # $Header:  $ — we're not using Subversion. 
There is no point in keeping 'changelog'-files because you can always run 'git log' or 'git blame'.
Please remove any VI, VIM and similar lines from ebuilds and files. 
Use tabs for indentation whenever possible.

Optional
========

Binhost
-------

Gentoo is not about compiling everything, don't waste your time on that. It is about customization.
If you want to stick to the standards for 90% of all packages and if you are only interested in
changing *USE flags* for the 10% where it matters - excellent. That is what the **binhosts** are for.

Find pre-compiled Gentoo packages here:

:corei7-avx (64b): https://binhost.ossdl.de/AMD64/Intel/corei7-avx/x86_64-pc-linux-gnu/

Obviously you will have to point Gentoo's *Portage* to these overlays. Modify your **make.conf** as follows::

    FEATURES="parallel-fetch getbinpkg"
    PORTAGE_BINHOST="https://binhost.ossdl.de/AMD64/Intel/corei7-avx/x86_64-pc-linux-gnu/"

-- Mark Kubacki, 2012-08-01, 2012-09-29, 2013-08-10
