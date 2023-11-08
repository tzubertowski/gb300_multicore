#!/bin/bash

#not working
make CONSOLE=uw8		CORE=cores/libretro-uw8	&& \
make CONSOLE=gw			CORE=cores/libretro-gw	&& \
make CONSOLE=vmu		CORE=cores/libretro-vemulator	&& \
make CONSOLE=cps1		CORE=cores/fbalpha2012_cps1	&& \
make CONSOLE=neogeo		CORE=cores/fbalpha2012_neogeo	&& \
make CONSOLE=mame2003mw	CORE=cores/mame2003_midway	&& \
make CONSOLE=jag		CORE=cores/libretro-virtualjaguar	&& \
make CONSOLE=cball		CORE=cores/cannonball	&& \
make CONSOLE=zork		CORE=cores/mojozork	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=img		CORE=cores/libretro-imageviewer-legacy	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=snesc		CORE=cores/chimerasnes	&& \
make CONSOLE=zx81		CORE=cores/libretro-81	&& \
make CONSOLE=3do		CORE=cores/libretro-opera	&& \
make CONSOLE=amstradb	CORE=cores/libretro-cap32	&& \
make CONSOLE=cps2		CORE=cores/fbalpha2012_cps2	&& \
make CONSOLE=cps3		CORE=cores/fbalpha2012_cps3/svn-current/trunk	MAKEFILE=-fmakefile.libretro	&& \
make CONSOLE=bk			CORE=cores/bk-emulator	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=fake08		CORE=cores/fake-08/platform/libretro	&& \
make CONSOLE=glxy		CORE=cores/libretro-galaxy	&& \
make CONSOLE=tennis		CORE=cores/retro-tennis	&& \
make CONSOLE=wolf		CORE=cores/ecwolf/src/libretro	&& \
make CONSOLE=int		CORE=cores/FreeIntv	&& \
make CONSOLE=mgba		CORE=cores/mgba	&& \
make CONSOLE=snesn		CORE=cores/snes9x-next	&& \
make CONSOLE=x68k		CORE=cores/libretro-px68k	&& \
make CONSOLE=psx		CORE=cores/libretro-beetle-psx	&& \
make CONSOLE=vec		CORE=cores/libretro-vecx	&& \

#make CONSOLE=fba		CORE=cores/fbalpha2012/svn-current/trunk	MAKEFILE=-fmakefile.libretro	&& \
#make -j5 -C cores/FBNeo/src/burner/libretro platform=sf2000 generate-files	&& make CONSOLE=fbn		CORE=cores/FBNeo/src/burner/libretro	&& \

#fully working
make CONSOLE=a26		CORE=cores/libretro-stella2014	&& \
make CONSOLE=lnx		CORE=cores/libretro-handy	&& \
make CONSOLE=chip8		CORE=cores/jaxe	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=col		CORE=cores/Gearcoleco/platforms/libretro	&& \
make CONSOLE=fcf		CORE=cores/FreeChaF	&& \
make CONSOLE=retro8		CORE=cores/retro8	&& \
make CONSOLE=vapor		CORE=cores/vaporspec/machine	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=2048		CORE=cores/libretro-2048	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=gong		CORE=cores/gong	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=prboom		CORE=cores/libretro-prboom	&& \
make CONSOLE=cdg		CORE=cores/libretro-pocketcdg	&& \
make CONSOLE=gme		CORE=cores/libretro-gme	&& \
make CONSOLE=pce		CORE=cores/libretro-beetle-pce-fast	&& \
make CONSOLE=ngpc		CORE=cores/RACE	&& \
make CONSOLE=gba		CORE=cores/gpsp	&& \
make CONSOLE=gb			CORE=cores/libretro-tgbdual	&& \
make CONSOLE=nes		CORE=cores/libretro-fceumm	&& \
make CONSOLE=snes02		CORE=cores/snes9x2002	&& \
make CONSOLE=snes		CORE=cores/snes9x2005	&& \
make CONSOLE=sega		CORE=cores/picodrive	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=gg			CORE=cores/Gearsystem/platforms/libretro	&& \
make CONSOLE=spec		CORE=cores/libretro-fuse	&& \
make CONSOLE=thom		CORE=cores/theodore	&& \
make CONSOLE=wsv		CORE=cores/potator/platform/libretro	&& \
make CONSOLE=m2k		CORE=cores/libretro-mame2000	&& \

#working but issues
make CONSOLE=amstrad	CORE=cores/libretro-crocods	&& \
make CONSOLE=mame2003	CORE=cores/libretro-mame2003-plus	&& \
make CONSOLE=arduboy	CORE=cores/arduous	&& \
make CONSOLE=a5200		CORE=cores/a5200	&& \
make CONSOLE=a78		CORE=cores/libretro-prosystem	&& \
make CONSOLE=lnxb		CORE=cores/libretro-beetle-lynx	&& \
make CONSOLE=wswan		CORE=cores/libretro-beetle-wswan	&& \
make CONSOLE=lowres-nx	CORE=cores/lowres-nx/platform/LibRetro	&& \
make CONSOLE=mrboom		CORE=cores/libretro-mrboom	&& \
make CONSOLE=jnb		CORE=cores/libretro-jumpnbump	&& \
make CONSOLE=cavestory	CORE=cores/libretro-nxengine	&& \
make CONSOLE=flashback	CORE=cores/REminiscence	&& \
make CONSOLE=o2em		CORE=cores/libretro-o2em	&& \
make CONSOLE=pcesgx		CORE=cores/libretro-beetle-supergrafx	&& \
make CONSOLE=pcfx		CORE=cores/libretro-beetle-pcfx	&& \
make CONSOLE=vb			CORE=cores/libretro-beetle-vb	&& \
make CONSOLE=sms		CORE=cores/smsplus-gx	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=gpgx		CORE=cores/Genesis-Plus-GX	MAKEFILE=-fMakefile.libretro	&& \
make CONSOLE=xmil		CORE=cores/libretro-xmil/libretro	&& \

#test cores
make CONSOLE=testadv		CORE=cores/libretro-samples/tests/test_advanced	&& \
make CONSOLE=testwav		CORE=cores/libretro-samples/audio/audio_playback_wav	&& \


true