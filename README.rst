========================
OSSDL overlay for Gentoo
========================
:Info: See `W-Mark Kubacki's blog <http://mark.ossdl.de/tag/ossdl-overlay/>`_ for news and discussions.
:Author: W-Mark Kubacki <wmark+overlay@hurrikane.de> et al.
:primary source: http://git.ossdl.de/
:mirror: http://github.com/wmark/ossdl-overlay

Installation and Usage
======================
To install::

    mkdir -p /var/portage/overlays
    cd $_
    git clone [adress-of-overlay] ossdl

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

If a package has been "keyworded" by the Gentoo devs and I don't encounter any errors anddeem it 
stable/sufficient enough for production use then the keyword is stripped in this overlay (thus 
marking the package as 'stable'). That tests are limited to the following systems/architectures:

- Intel — 2nd and 3rd generation Core/Xeons
- AMD — Phenom II and Istanbul (sorry, cannot test on K8)
- ARM — SheevaPlug (ARM9) and Cortex-A15 multicore server (cannot disclose more due to NDA)

If you want to include an ebuild into this overlay then please fork it, add your ebuild, and finally
email me the link. Whenever I write 'me' in this README indeed 'us' is meant. ;-)
You can get commit-access to this git repository if you're willing to keep that package up-to-date.

You — and that includes Gentoo developers — are not allowed to strip any Copyright lines. Whenever
you add something non-trivial just add your name to any existing list with a matching year or in
a separate line, should such list not already exist.

Remove any values between dollar-signs retaining the key, for example: # $Header:  $, and remove
changelog-files  — we're not using Subversion. Remove any VI, VIM and similar lines from ebuilds 
and files. Use tabs for indentation whenever possible.

Optional
========

Portage configurations
----------------------

You can find ready portage configuration files - (un)maskings, keywordings and package.use - online
at http://git.ossdl.de/portage-configurations . You will have to pick an appropriate branch, though.

For example, for latest AMD processors of the *amdfam10* [1]_ family::

    cd /etc
    rm -r make.conf portage
    git clone -b amdfam10 https://bitbucket.org/wmark/portage-configurations.git
    ln -s portage/make.conf

Binhost
-------

Gentoo is not about compiling everything, don't waste your time on that. It is about customization.
If you want to stick to the standards for 90% of all packages and if you are only interested in
changing *USE flags* for the 10% where it matters - excellent. That is what the **binhosts** are for.

Find pre-compiled Gentoo packages for your architecture [1]_ here:

:ARM9 (32b): http://binhost.ossdl.de/ARM/armv5tel-softfloat-linux-gnueabi/
:amdfam10 (64b): http://binhost.ossdl.de/AMD64/AMD/fam10-fam16/x86_64-pc-linux-gnu/
:nocona (64b): http://binhost.ossdl.de/AMD64/Intel/CoreIx/x86_64-pc-linux-gnu/

Obviously you will have to point Gentoo's *Portage* to these overlays. Modify your **make.conf** as follows::

    FEATURES="parallel-fetch getbinpkg"
    PORTAGE_BINHOST="http://binhost.ossdl.de/AMD64/Intel/CoreIx/x86_64-pc-linux-gnu/"

-- W-Mark Kubacki, 2012-08-01, 2012-09-29

.. [1] The *architectures* correspond with GCC's ``--march`` flag (modern Xeon, Core iX --> nocona; 
   Phenom, Opteron (including Istanbul) --> amdfam10).
   ARM9 is meant for and tested on SheevaPlugs with Marvell's Feroceon SoC.
