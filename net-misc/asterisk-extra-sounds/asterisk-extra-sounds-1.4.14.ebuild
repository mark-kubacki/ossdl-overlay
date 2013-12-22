# Copyright 1999-2013 Gentoo Foundation
# Copyright 2013 Mark Kubacki
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Extra sounds for asterisk"
HOMEPAGE="http://www.asterisk.org/"
LINGUAS="^en fr" # ^ is used to indicate to the loops below to NOT set this as an optional
CODECS="alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav"

SRC_URI=""
IUSE="opus ${CODECS}"
for l in ${LINGUAS}; do
	[[ "${l}" != ^* ]] && IUSE+=" linguas_${l}" && SRC_URI+=" linguas_${l}? ("
	for c in ${CODECS}; do
		SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz )"
	done
	[[ "${l}" = ^* ]] || SRC_URI+=" )"
done
RESTRICT="primaryuri"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86 arm"

# virtual/mysql is needed for command 'replace'
DEPEND=">=net-misc/asterisk-1.4
	opus? (	media-sound/opus-tools
		sys-apps/findutils
		virtual/mysql
	)
	"
REQUIRED_USE="opus? ( wav )"

S="${WORKDIR}"

src_unpack() {
	local ar

	for ar in ${A}; do
		l="${ar#${PN}-}"
		l=${l%%-*}
		echo ">>> Unpacking $ar to ${WORKDIR}/${l}"
		[ -d "${WORKDIR}/${l}" ] || mkdir "${WORKDIR}/${l}" || die "Error creating unpack directory"
		tar xf "${DISTDIR}/${ar}" -C "${WORKDIR}/${l}" || die "Error unpacking ${ar}"
	done
}

src_compile() {
	if use opus; then
		ebegin "Encoding WAV to OPUS"
			# Asterisk clients need 18kbit OPUS files
			find -type f -name '*.wav' -print0 \
			| replace ".wav" "" \
			| xargs --max-procs=4 --max-args=1 --no-run-if-empty -0 -I '{}' \
				opusenc --bitrate 18 --cvbr --comp 10 --quiet '{}'.wav '{}'.opus
		eend $?
	fi
}

src_install() {
	for l in ${LINGUAS}; do
		if [[ "${l}" = ^* ]] || use linguas_${l}; then
			l="${l#^}"
			dodoc ${l}/CHANGES-${PN%-sounds}-${l}-${PV} ${l}/${PN#asterisk-}-${l}.txt
			rm ${l}/CHANGES-${PN%-sounds}-${l}-${PV} ${l}/${PN#asterisk-}-${l}.txt
		fi
	done

	diropts -m 0770 -o asterisk -g asterisk
	insopts -m 0660 -o asterisk -g asterisk

	dodir /var/lib/asterisk/sounds
	insinto /var/lib/asterisk/sounds
	doins -r .
}

pkg_postinst() {
	local c has_once_codec=

	for c in ${CODECS}; do
			use ${c#+} && has_one_codec=1
	done

	[ -n "${has_one_codec}" ] || ewarn "You have none of the codec use flags (${CODECS}) set.  You need to have at least one set in order for this package to be useful."
}
