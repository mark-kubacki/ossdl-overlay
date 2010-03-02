========================
OSSDL overlay for Gentoo
========================
:Info: See `W-Mark Kubacki's blog <http://mark.ossdl.de/tag/ossdl-overlay/>`_ for news and discussions.
:Author: W-Mark Kubacki <wmark+overlay@hurrikane.de> et al.
:primary source: `git at ossdl <http://git.ossdl.de/>`_
:mirror: at `github <http://github.com/wmark/ossdl-overlay>`_

Installation
============
To install:

    mkdir -p /usr/local/overlays
    cd /usr/local/overlays
    git clone [adress-of-overlay] ossdl

    nano /etc/portage/make.conf
    PORTDIR_OVERLAY="/usr/local/overlays/ossdl"

By the next "emerge --sync" or "eix-sync" the new packages should be displayed at search.

Optional
========

Portage configurations
----------------------

You can find ready portage configuration files - (un)maskings, keywordings and package.use - online
at `git at ossdl <http://git.ossdl.de/>`_. You will have to pick an appropriate branch, though.

For example, for latest AMD processors of the amdfam10 family (Phenom, Opteron...):

    cd /etc
    rm -r make.conf portage
    git clone -b amdfam10 http://git.ossdl.de/r/portage.git
    ln -s portage/make.conf

Binhosts
--------

Gentoo is not about compiling everything, don't waste your time on that. It is about customization.
If you want to stick to the standards for 90% of all packages and if you are only interested about
changing USE flags for the 10% where it matters - excellent. That is what the binhosts are for.

Find pre-compiled Gentoo packages for your architecture here:

:ARM9 (32b): http://binhost.ossdl.de/armv5tel-softfloat-linux-gnueabi/
:amdfam10 (64b): http://binhost.ossdl.de/x86_64-pc-linux-gnu/
:nocona (64b): http://binhost.ossdl.de/x86_64-pc-linux-gnu-nocona/

Obviously you will have to point Gentoo's Portage to these overlays. Modify your make.conf as follows:

    FEATURES="parallel-fetch getbinpkg"
    PORTAGE_BINHOST="http://binhost.ossdl.de/x86_64-pc-linux-gnu/"

The 'architectures' correspond with GCC's --march flag (modern Xeon --> nocona; 
Phenom, Opteron (including Istanbul) --> amdfam10).
ARM9 is meant and tested on SheevaPlugs, but should work on Iphone, too.

-- W-Mark Kubacki, 2010-03-02
