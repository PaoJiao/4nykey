# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greginvm/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/greginvm/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/greginvm/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
PATCHES=( "${FILESDIR}"/${PN}-noscm.diff )