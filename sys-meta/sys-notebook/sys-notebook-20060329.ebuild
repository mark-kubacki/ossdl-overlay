# Copyright 2006 Ossdl.de, Hurrikane Systems
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="do not merge this yourself, this will be the base of a specific system configuration"
HOMEPAGE="http://www.ossdl.de/"

LICENSE="GPL-2 Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE_VIDEO_CARDS="
	video_cards_ati
	video_cards_fglrx
	"
IUSE="${IUSE_VIDEO_CARDS}"

RDEPEND="
	>=sys-meta/sys-base-${PV}
	media-sound/alsa-tools
	media-sound/alsa-utils
	|| (
		video_cards_ati? ( media-video/rovclock )
		video_cards_fglrx? ( media-video/rovclock )
	)
	sys-apps/coldplug
	sys-apps/hotplug
	sys-apps/pcmciautils
	sys-fs/udev
	sys-power/cpufreqd
	sys-power/powermgmt-base
	"
