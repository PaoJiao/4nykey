# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}/TTF"
inherit font-r1

DESCRIPTION="Free-use OpenType font"
HOMEPAGE="http://01.org/clearsans"
SRC_URI="https://01.org/sites/default/files/downloads/clear-sans/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
