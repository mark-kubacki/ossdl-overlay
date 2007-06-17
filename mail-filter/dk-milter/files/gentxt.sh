#!/bin/bash
##
## $Id: gentxt.sh,v 1.1 2006/07/15 23:47:38 langthang Exp $
##
## Copyright (c) 2004, 2005 Sendmail, Inc. and its suppliers.
## All rights reserved.
##
## gentxt.csh -- generate a TXT record for DomainKeys service
##
## Usage: gentext.csh <selector> [<domain>]
##
## This will write a TXT record suitable for insertion into a DNS zone file
## on standard output, and the matching public/private keys will be in
## PEM-formatted files called <selector>.public and <selector>.private,
## respectively, in the current directory.
##
## To translate the record produced by this script, see the DomainKeys
## draft.  The script will output a record which advertises an RSA-style
## public key in test mode.

## langthang@gentoo.org (15 July 2006)
## bash is gentoo default shell
## convert to bash

# verify usage
if [[ "$3" != "" || "$1" == "" ]] ; then
	echo "usage: $0 selector [domain]"
	exit 1
fi

# copy the argument
selector="$1"
domain="$2"

# generate a private key
openssl genrsa -out ${selector}.private 512 >& /dev/null

# generate a public key based on the private key
openssl rsa -in ${selector}.private -out ${selector}.public -pubout \
	-outform PEM >& /dev/null

# prepare the data
keydata=`grep -v '^-' ${selector}.public`
pubkey=`echo $keydata | sed 's/ //'`

# output the record
echo -n ${selector}._domainkey   IN   TXT  '"'g=\; k=rsa\; t=y\; p=$pubkey'"'
if [[ "$domain" != "" ]] ; then
	echo " ; ----- DomainKey $selector for $domain"
else
	echo ""
fi
