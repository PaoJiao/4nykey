# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-1.0_pre8-r1.ebuild,v 1.12 2006/10/06 12:43:24 blubb Exp $

inherit flag-o-matic linux-mod subversion confutils

BLUV=1.6
SVGV=1.9.17
NBV=610
WBV=600
SKINDIR="/usr/share/mplayer/skins/"
DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"
SRC_URI="
	bitmap-fonts? (
		mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
		mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
		mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
	)
	svga? ( http://mplayerhq.hu/~alex/svgalib_helper-${SVGV}-mplayer.tar.bz2 )
	gtk? ( mirror://mplayer/Skin/Blue-${BLUV}.tar.bz2 )
"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"
ESVN_PATCHES="${PN}-*.diff"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE="
3dnow 3dnowext aac aalib alsa amr arts bindist bitmap-fonts bidi bl cdio
cpudetection custom-cflags debug dga doc dts dvb cdparanoia directfb dv dvd
dvdread dvdnav enca encode esd external-faad external-ffmpeg fbcon fontconfig
gif ggi gtk ipv6 jack joystick jpeg ladspa libcaca lirc live livecd lzo mad
matrox mmx mmxext musepack nas openal opengl oss png real rtc samba sdl speex
sse sse2 svga tga theora tremor truetype v4l v4l2 vorbis win32codecs X x264
xanim xinerama xv xvid xvmc twolame color radio examples kernel_linux zoran
"

VIDEO_CARDS="s3virge mga tdfx vesa"
for x in ${VIDEO_CARDS}; do
	IUSE="${IUSE} video_cards_${x}"
done

# 'encode' in USE for MEncoder.
RDEPEND="
	xvid? ( >=media-libs/xvid-0.9.0 )
	win32codecs? (
		!livecd? (
			!bindist? ( >=media-libs/win32codecs-20040916 ) ) )
	x86? ( real? ( >=media-video/realplayer-10.0.3 ) )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	openal? ( media-libs/openal )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	directfb? ( dev-libs/DirectFB )
	dts? ( media-libs/libdts )
	dvb? ( media-tv/linuxtv-dvb-headers )
	dvd? ( dvdread? ( media-libs/libdvdread ) )
	encode? (
		media-sound/lame
		media-sound/twolame
		dv? ( >=media-libs/libdv-0.9.5 )
		aac? ( media-libs/faac )
		x264? ( >=media-libs/x264-45 )
	)
	esd? ( media-sound/esound )
	external-ffmpeg? ( ~media-video/ffmpeg-9999 )
	enca? ( app-i18n/enca )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi )
	jpeg? ( media-libs/jpeg )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	lzo? ( dev-libs/lzo )
	mad? ( media-libs/libmad )
	musepack? ( >=media-libs/libmpcdec-1.2.2 )
	nas? ( media-libs/nas )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	samba? ( >=net-fs/samba-2.2.8a )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	live? ( >=media-plugins/live-2004.07.20 )
	truetype? ( >=media-libs/freetype-2.1 )
	jack? ( media-sound/jack-audio-connection-kit )
	xanim? ( >=media-video/xanim-2.80.1-r4 )
	external-faad? ( media-libs/faad2 )
	sys-libs/ncurses
	dvdnav? ( media-libs/libdvdnav )
	ladspa? ( media-libs/ladspa-sdk )
	fontconfig? ( media-libs/fontconfig )
	X? (
		x11-libs/libXxf86vm
		x11-libs/libXext
		dga? ( x11-libs/libXxf86dga )
		xv? (
			x11-libs/libXv
			xvmc? ( x11-libs/libXvMC )
		)
		xinerama? (
			x11-libs/libXinerama
		)
		gtk? (
			media-libs/libpng
			x11-libs/libXi
			=x11-libs/gtk+-2*
			=dev-libs/glib-2*
		)
	)
	amr? ( media-libs/amrnb media-libs/amrwb )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xml-dtd-4.1.2
	)
	X? (
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
		dga? ( x11-proto/xf86dgaproto )
		xv? (
			x11-proto/videoproto
		)
		xinerama? ( x11-proto/xineramaproto )
	)
"

pkg_setup() {
	if use real && use x86; then
		REALLIBDIR="/opt/RealPlayer/codecs"
	fi
	LINGUAS="en"
}

src_unpack() {
	subversion_src_unpack

	cd ${WORKDIR}

	if use bitmap-fonts; then
		unpack \
			font-arial-iso-8859-1.tar.bz2 font-arial-iso-8859-2.tar.bz2 \
			font-arial-cp1250.tar.bz2
	fi


	use X && use gtk && unpack Blue-${BLUV}.tar.bz2

	if use svga
	then
		unpack svgalib_helper-${SVGV}-mplayer.tar.bz2

		echo
		einfo "Enabling svga non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo " to actually use this)"
		echo

		mv ${WORKDIR}/svgalib_helper libdha
	fi

	cd ${S}

	# skip make distclean/depend
	touch .developer
	sed -i '/\$(MAKE) depend/d' Makefile
}

src_compile() {

	local myconf="${myconf} --disable-tv-bsdbt848 --disable-vidix-external"
	################
	#Optional features#
	###############
	if use cpudetection || use livecd || use bindist
	then
	myconf="${myconf} --enable-runtime-cpudetection"
	fi

	enable_extension_disable fribidi bidi

	enable_extension_disable enca enca

	if use cdio; then
		myconf="${myconf} --disable-cdparanoia"
	else
		enable_extension_disable cdparanoia cdparanoia
	fi

	if use external-ffmpeg; then
	# use shared ffmpeg libs (not supported),
	# except for avutil (actively not supported)
		for lib in avcodec avformat postproc; do
			myconf="${myconf} --disable-lib${lib}_a"
		done
	fi

	if use dvd; then
		if ! use dvdnav; then
			myconf="${myconf} --disable-dvdnav"
			if use dvdread; then
				myconf="${myconf} --disable-dvdread-internal --disable-libdvdcss-internal"
			else
				myconf="${myconf} --disable-dvdread"
			fi
		fi
	else
		myconf="${myconf} --disable-dvdread --disable-dvdnav --disable-dvdread-internal --disable-libdvdcss-internal"
	fi

	if use encode ; then
		enable_extension_disable libdv dv
		enable_extension_disable x264 x264
		enable_extension_disable twolame twolame
		enable_extension_disable faac aac
	else
		myconf="${myconf} --disable-mencoder --disable-libdv --disable-x264 --disable-twolame --disable-faac"
	fi

	if use !X; then
		myconf="${myconf} --disable-gui --disable-x11 --disable-xv --disable-xmga --disable-xinerama --disable-vm --disable-xvmc"
	else
		#note we ain't touching --enable-vm.  That should be locked down in the future.
		myconf="${myconf} $(use_enable gtk gui)"
		enable_extension_disable xinerama xinerama
		enable_extension_disable xv xv
	fi

	if use X; then
		enable_extension_disable dga2 dga
	else
		myconf="${myconf} --disable-dga2"
	fi

	# disable png *only* if gtk && png aren't on
	if ! use png || ! use gtk; then
		myconf="${myconf} --disable-png"
	fi
	enable_extension_disable inet6 ipv6
	myconf="${myconf} $(use_enable joystick)"
	enable_extension_disable lirc lirc
	enable_extension_disable live live
	enable_extension_disable rtc rtc
	enable_extension_disable smb samba
	enable_extension_disable bitmap-font bitmap-fonts
	enable_extension_disable freetype truetype
	enable_extension_disable fontconfig fontconfig
	myconf="${myconf} $(use_enable color color-console)"
	if use !v4l && use !v4l2; then
		myconf="${myconf} --disable-tv"
	else
		enable_extension_disable tv-v4l1 v4l
		enable_extension_disable tv-v4l2 v4l2
	fi
	myconf="${myconf} $(use_enable radio) $(use_enable radio radio-capture)"
	if use radio; then
		enable_extension_disable radio-v4l v4l
		enable_extension_disable radio-v4l2 v4l2
	fi

	#######
	# Codecs #
	#######
	enable_extension_disable gif gif
	enable_extension_disable jpeg jpeg
	enable_extension_disable ladspa ladspa
	enable_extension_disable libdts dts
	enable_extension_disable liblzo lzo
	enable_extension_disable musepack musepack
	if use aac; then
		use external-faad && myconf="${myconf} --disable-faad-internal"
	else
		myconf="${myconf} --disable-faad-internal --disable-faad-external"
	fi
	if use vorbis; then
		enable_extension_disable tremor-internal tremor
		enable_extension_disable tremor-external tremor
	else
		myconf="${myconf} --disable-vorbis"
	fi
	enable_extension_disable theora theora
	enable_extension_disable speex speex
	enable_extension_disable xvid xvid
	use x86 && enable_extension_disable real real
	! use livecd && ! use bindist && \
		enable_extension_disable win32dll win32codecs
	enable_extension_disable amr_nb amr
	enable_extension_disable amr_wb amr

	#############
	# Video Output #
	#############
	enable_extension_disable dvbhead dvb
	use dvb && myconf="${myconf} --with-dvbincdir=/usr/include"

	enable_extension_disable aa aalib
	enable_extension_disable directfb directfb
	enable_extension_disable fbdev fbcon
	use fbcon && enable_extension_disable s3fb video_cards_s3virge
	enable_extension_disable ggi ggi
	enable_extension_disable caca libcaca
	use X && enable_extension_disable xmga matrox
	enable_extension_disable mga matrox
	enable_extension_disable gl opengl
	enable_extension_disable vesa video_cards_vesa
	enable_extension_disable sdl sdl

	enable_extension_disable svga svga
	enable_extension_disable vidix-internal svga
	enable_extension_disable zr zoran

	enable_extension_disable tga tga

	if use xv; then
		if use xvmc; then
			myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCW"
		else
			myconf="${myconf} --disable-xvmc"
		fi
	else
		myconf="${myconf} --disable-xv --disable-xvmc"
	fi

	if ! use kernel_linux && ! use video_cards_mga; then
		 myconf="${myconf} --disable-mga --disable-xmga"
	fi

	if use video_cards_tdfx; then
		myconf="${myconf} $(use_enable video_cards_tdfx tdfxvid) \
			$(use_enable fbcon tdfxfb)"
	else
		myconf="${myconf} --disable-3dfx --disable-tdfxvid --disable-tdfxfb"
	fi

	#############
	# Audio Output #
	#############
	enable_extension_disable alsa alsa
	enable_extension_disable jack jack
	enable_extension_disable arts arts
	enable_extension_disable esd esd
	enable_extension_disable mad mad
	enable_extension_disable nas nas
	enable_extension_disable openal openal
	enable_extension_disable ossaudio oss

	#################
	# Advanced Options #
	#################
	if use x86; then
		enable_extension_disable 3dnow 3dnow
		enable_extension_disable 3dnowext 3dnowext
		enable_extension_disable sse sse
		enable_extension_disable sse2 sse2
		enable_extension_disable mmx mmx
		enable_extension_disable mmxext mmxext
	fi
	use debug && myconf="${myconf} --enable-debug=3"

	if use xanim
	then
		myconf="${myconf} --with-xanimlibdir=/usr/lib/xanim/mods"
	fi

	if [ -e /dev/.devfsd ]
	then
		myconf="${myconf} --enable-linux-devfs"
	fi

	# support for blinkenlights
	use bl && myconf="${myconf} --enable-bl"

	#leave this in place till the configure/compilation borkage is completely corrected back to pre4-r4 levels.
	# it's intended for debugging so we can get the options we configure mplayer w/, rather then hunt about.
	# it *will* be removed asap; in the meantime, doesn't hurt anything.
	echo "${myconf}" > ${T}/configure-options

	if use custom-cflags
	then
	# let's play the filtration game!  MPlayer hates on all!
	#strip-flags
	# ugly optimizations cause MPlayer to cry on x86 systems!
		if use x86 ; then
			replace-flags -O0 -O2
			replace-flags -O3 -O2
			filter-flags -fPIC -fPIE
		fi
	else
	unset CFLAGS CXXFLAGS
	fi

	CFLAGS="$CFLAGS" ./configure \
		--prefix=/usr \
		--confdir=/usr/share/mplayer \
		--datadir=/usr/share/mplayer \
		--enable-largefiles \
		--enable-menu \
		--enable-network --enable-ftp \
		--realcodecsdir=${REALLIBDIR} \
		${myconf} || die

	# we run into problems if -jN > -j1
	# see #86245
	MAKEOPTS="${MAKEOPTS} -j1"

	einfo "Make"
	emake || die "Failed to build MPlayer!"
	use doc && make -C ${S}/DOCS/xml html-chunked-en
	einfo "Make completed"
}

src_install() {

	einfo "Make install"
	make prefix=${D}/usr \
		BINDIR=${D}/usr/bin \
		LIBDIR=${D}/usr/$(get_libdir) \
		CONFDIR=${D}/usr/share/mplayer \
		DATADIR=${D}/usr/share/mplayer \
		MANDIR=${D}/usr/share/man \
		INSTALLSTRIP='' \
		LDCONFIG=/bin/true \
		install || die "Failed to install MPlayer!"
	einfo "Make install completed"

	dodoc AUTHORS ChangeLog README
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		dohtml -r "${S}"/DOCS/HTML/en/*
		cp -r "${S}/DOCS/tech" "${D}/usr/share/doc/${PF}/"
	fi
	if use examples ; then
		# Copy misc tools to documentation path, as they're not installed directly
		# and yes, we are nuking the +x bit.
		find "${S}/TOOLS" -type d | xargs -- chmod 0755
		find "${S}/TOOLS" -type f | xargs -- chmod 0644
		cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die
	fi

	# Install the default Skin and Gnome menu entry
	if use X && use gtk; then
		if [ -d "${ROOT}${SKINDIR}default" ]; then dodir ${SKINDIR}; fi
		cp -r ${WORKDIR}/Blue ${D}${SKINDIR}default || die

		# Fix the symlink
		rm -rf ${D}/usr/bin/gmplayer
		dosym mplayer /usr/bin/gmplayer
	fi

	if use bitmap-fonts; then
		dodir /usr/share/mplayer/fonts
		local x=
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for x in $(find ${WORKDIR}/ -type d -name 'font-arial-*')
		do
			cp -Rd ${x} ${D}/usr/share/mplayer/fonts
		done
		# Fix the font symlink ...
		rm -rf ${D}/usr/share/mplayer/font
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc
	newins ${S}/etc/example.conf mplayer.conf
	dosed -e 's/include =/#include =/' /etc/mplayer.conf
	dosed -e 's/fs=yes/fs=no/' /etc/mplayer.conf
	dosym ../../../etc/mplayer.conf /usr/share/mplayer/mplayer.conf

	# mv the midentify script to /usr/bin for emovix.
	insinto /usr/bin
	insopts -m0755
	doins TOOLS/midentify
	insinto /usr/share/mplayer
	dodoc ${S}/etc/codecs.conf
	doins ${S}/etc/input.conf
	doins ${S}/etc/menu.conf
}

pkg_preinst() {

	if [ -d "${ROOT}${SKINDIR}default" ]
	then
		rm -rf ${ROOT}${SKINDIR}default
	fi
}

pkg_postinst() {

	if use matrox; then
		depmod -a &>/dev/null || :
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L ${ROOT}/usr/share/mplayer/font -a \
	     ! -e ${ROOT}/usr/share/mplayer/font ]
	then
		rm -f ${ROOT}/usr/share/mplayer/font
	fi

	if [ -L ${ROOT}/usr/share/mplayer/subfont.ttf -a \
	     ! -e ${ROOT}/usr/share/mplayer/subfont.ttf ]
	then
		rm -f ${ROOT}/usr/share/mplayer/subfont.ttf
	fi
}

