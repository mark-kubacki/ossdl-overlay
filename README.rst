========================
OSSDL overlay for Gentoo
========================
:Info: See `W-Mark Kubacki's blog <http://mark.ossdl.de/tag/ossdl-overlay/>`_ for news and discussions.
:Author: W-Mark Kubacki <wmark+overlay@hurrikane.de> et al.
:primary source: http://git.ossdl.de/
:mirror: http://github.com/wmark/ossdl-overlay

Installation
============
To install::

    mkdir -p /usr/local/overlays
    cd /usr/local/overlays
    git clone [adress-of-overlay] ossdl

    nano /etc/portage/make.conf
    PORTDIR_OVERLAY="/usr/local/overlays/ossdl"

By the next ``emerge --sync`` or ``eix-sync`` the new packages should be available for search.

Optional
========

Portage configurations
----------------------

You can find ready portage configuration files - (un)maskings, keywordings and package.use - online
at http://git.ossdl.de/ . You will have to pick an appropriate branch, though.

For example, for latest AMD processors of the *amdfam10* [1]_ family::

    cd /etc
    rm -r make.conf portage
    git clone -b amdfam10 http://git.ossdl.de/r/portage.git
    ln -s portage/make.conf

Binhosts
--------

Gentoo is not about compiling everything, don't waste your time on that. It is about customization.
If you want to stick to the standards for 90% of all packages and if you are only interested about
changing *USE flags* for the 10% where it matters - excellent. That is what the **binhosts** are for.

Find pre-compiled Gentoo packages for your architecture [1]_ here:

.. [1] The *architectures* correspond with GCC's ``--march`` flag (modern Xeon --> nocona; 
   Phenom, Opteron (including Istanbul) --> amdfam10).
   ARM9 is meant and tested on SheevaPlugs, but should work on Iphone, too.

:ARM9 (32b): http://binhost.ossdl.de/armv5tel-softfloat-linux-gnueabi/
:amdfam10 (64b): http://binhost.ossdl.de/x86_64-pc-linux-gnu/
:nocona (64b): http://binhost.ossdl.de/x86_64-pc-linux-gnu-nocona/

Obviously you will have to point Gentoo's *Portage* to these overlays. Modify your **make.conf** as follows::

    FEATURES="parallel-fetch getbinpkg"
    PORTAGE_BINHOST="http://binhost.ossdl.de/x86_64-pc-linux-gnu/"

-- W-Mark Kubacki, 2010-03-02
