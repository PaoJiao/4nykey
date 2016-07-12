# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://wimlib.net/${PN}"
else
	inherit vcs-snapshot
	SRC_URI="https://wimlib.net/downloads/${P}.tar.gz"
	SRC_URI="
		https://wimlib.net/git/?p=wimlib;a=snapshot;h=refs/tags/v${PV};sf=tgz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="The open source Windows Imaging (WIM) library"
HOMEPAGE="https://wimlib.net/"

LICENSE="|| ( GPL-3+ LGPL-3+ ) CC0-1.0"
SLOT="0"
IUSE="cpu_flags_x86_ssse3 fuse ntfs openssl yasm"
REQUIRED_USE="cpu_flags_x86_ssse3? ( !openssl )"

RDEPEND="
	dev-libs/libxml2:2
	ntfs? ( sys-fs/ntfs3g )
	fuse? ( sys-fs/fuse )
	openssl? ( dev-libs/openssl:0 )
"
DEPEND="
	${RDEPEND}
	cpu_flags_x86_ssse3? (
		yasm? ( dev-lang/yasm )
		!yasm? ( dev-lang/nasm )
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with ntfs ntfs-3g)
		$(use_with fuse)
		$(use_enable cpu_flags_x86_ssse3 ssse3-sha1)
		$(use_with openssl libcrypto)
	)
	ac_cv_prog_NASM="$(usex yasm yasm nasm)" \
		econf "${myeconfargs[@]}"
}