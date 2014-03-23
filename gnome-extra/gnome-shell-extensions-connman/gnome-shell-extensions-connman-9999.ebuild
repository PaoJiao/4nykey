# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 git-r3 autotools-utils

DESCRIPTION="An connman extension for GNOME Shell"
HOMEPAGE="https://github.com/connectivity/gnome-extension-connman"
SRC_URI=""
EGIT_REPO_URI="git://github.com/connectivity/gnome-extension-connman.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

AUTOTOOLS_AUTORECONF="1"

DEPEND="
	app-admin/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
"

pkg_postinst() {
	gnome2_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, to enable/disable extensions on a per-user basis,"
	elog "you can use the https://extensions.gnome.org/ web interface, the"
	elog "gnome-extra/gnome-tweak-tool GUI, or modify the org.gnome.shell"
	elog "enabled-extensions gsettings key from the command line or a script."
	elog
}