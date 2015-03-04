# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by 4th february"
HOMEPAGE="http://fonts.4thfebruary.com.ua"
BASE_URI="http://openfontlibrary.org/assets/downloads/"
SRC_URI="
${BASE_URI}blogger-sans/6d62f1b83637f460d54133976767d50a/blogger-sans.zip -> ${PN}-blogger-sans-2014-12-16.zip
${BASE_URI}designosaur/20b76920b181bc400c45166473687ed6/designosaur.zip -> ${PN}-designosaur-2011-05-26.zip
${BASE_URI}free-grotesque-web-font/3fd3bfdf68bdfe6155d42971455e5b88/free-grotesque-web-font.zip -> ${PN}-free-grotesque-web-font-2014-07-08.zip
${BASE_URI}monitorica/687a26ae356bc31511a27d9b320eaae3/monitorica.zip -> ${PN}-monitorica-2014-09-16.zip
${BASE_URI}sansus-webissimo/9e7ef959f7aeef22383039a04e56def9/sansus-webissimo.zip -> ${PN}-sansus-webissimo-2011-05-18.zip
"
RESTRICT="primaryuri"

LICENSE="CC-BY-ND-4.0 CC-BY-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""
FONT_SUFFIX="otf ttf"

src_prepare() {
	find "${S}" -type d -name 'Web' -print0 | xargs -0 rm -rf
	find "${S}" -mindepth 2 -type f -name '*.[ot]tf' -exec mv {} "${S}" \;
}