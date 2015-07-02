# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit linux-mod

MY_P="DPO_RT5572_LinuxSTA_${PV%.*}_${PV##*.}"
DESCRIPTION="Driver for the RaLink RT8070/RT3070/RT3370/RT3572/RT537x/RT5572 USB wireless chipsets"
HOMEPAGE="http://www.mediatek.com/en/downloads"
SRC_URI="http://cdn-cw.mediatek.com/Downloads/linux/${MY_P}.tar.bz2"
RESTRICT="primaryuri"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MODULE_NAMES="rt5572sta(net/wireless:${S}:${S}/os/linux)"
BUILD_PARAMS="LINUX_SRC=${KERNEL_DIR} HAS_WPA_SUPPLICANT=y HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y"
BUILD_TARGETS="all"
CONFIG_CHECK="WIRELESS_EXT"
MODULESD_RT3070STA_ALIASES=('ra? rt5572sta')
MODULESD_RT3070STA_DOCS="README* *.txt"

src_prepare() {
	sed -e '/cp.*tftpboot/d' -i Makefile
	epatch "${FILESDIR}"/${PN}.diff
}

src_install() {
	linux-mod_src_install
	insinto /etc/Wireless/RT2870STA
	doins RT2870STA*.dat
}
