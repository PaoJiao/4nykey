# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 subversion

DESCRIPTION="MPD applet for GNOME panel"
HOMEPAGE="http://www.musicpd.org"
SRC_URI=""
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"
ESVN_PATCHES="*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/gnome-panel-2.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS README TODO"
