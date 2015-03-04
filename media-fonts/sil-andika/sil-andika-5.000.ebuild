# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit unpacker font

DESCRIPTION="Andika is a sans serif font designed especially for literacy use"
HOMEPAGE="http://scripts.sil.org/Andika"
MY_P="Andika-${PV}"
MY_PC="AndikaCompact-${PV}"
BASE_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&"
SRC_URI="
	${BASE_URI}media_id=${MY_P}.zip&filename=${MY_P}.zip -> ${MY_P}.zip
	compact? (
	${BASE_URI}media_id=${MY_PC}.zip&filename=${MY_PC}.zip -> ${MY_PC}.zip
	)
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="compact"

RDEPEND=""
DEPEND="
	$(unpacker_src_uri_depends)
"

FONT_SUFFIX="ttf"
DOCS="
	${MY_P}/FONTLOG.txt
	${MY_P}/README.txt
	${MY_P}/documentation/${MY_P%-*}-features.pdf
"

src_prepare() {
	mv */*.ttf .
}