#!/bin/bash

#fully working
# echo "-- Amstradb make --"
# make clean CONSOLE=amstradb   CORE=cores/libretro-cap32
# make CONSOLE=amstradb   CORE=cores/libretro-cap32
# echo "-- m2k make --"
# make clean CONSOLE=m2k        CORE=cores/libretro-mame2000
# make CONSOLE=m2k        CORE=cores/libretro-mame2000
# echo "-- a26 make --"
# make clean CONSOLE=a26        CORE=cores/libretro-stella2014
# make CONSOLE=a26        CORE=cores/libretro-stella2014
# echo "-- a5200 make --"
# make clean CONSOLE=a5200      CORE=cores/a5200
# make CONSOLE=a5200      CORE=cores/a5200
# echo "-- a78 make --"
# make clean CONSOLE=a78        CORE=cores/libretro-prosystem
# make CONSOLE=a78        CORE=cores/libretro-prosystem
# echo "-- a800 make --"
# make clean CONSOLE=a800       CORE=cores/libretro-atari800lib
# make CONSOLE=a800       CORE=cores/libretro-atari800lib
# echo "-- lnx make --"
# make clean CONSOLE=lnx        CORE=cores/libretro-handy
# make CONSOLE=lnx        CORE=cores/libretro-handy
# echo "-- wswan make --"
# make clean CONSOLE=wswan      CORE=cores/libretro-beetle-wswan
# make CONSOLE=wswan      CORE=cores/libretro-beetle-wswan
# echo "-- chip8 make --"
# make clean CONSOLE=chip8      CORE=cores/jaxe MAKEFILE=-fMakefile.libretro
# make CONSOLE=chip8      CORE=cores/jaxe MAKEFILE=-fMakefile.libretro
# echo "-- col make --"
# make clean CONSOLE=col        CORE=cores/Gearcoleco/platforms/libretro
# make CONSOLE=col        CORE=cores/Gearcoleco/platforms/libretro
# echo "-- fcf make --"
# make clean CONSOLE=fcf        CORE=cores/FreeChaF
# make CONSOLE=fcf        CORE=cores/FreeChaF
# echo "-- retro8 make --"
# make clean CONSOLE=retro8     CORE=cores/retro8
# make CONSOLE=retro8     CORE=cores/retro8
# echo "-- vapor make --"
# make clean CONSOLE=vapor      CORE=cores/vaporspec/machine MAKEFILE=-fMakefile.libretro
# make CONSOLE=vapor      CORE=cores/vaporspec/machine MAKEFILE=-fMakefile.libretro
# echo "-- 2048 make --"
# #make clean CONSOLE=2048       CORE=cores/libretro-2048 MAKEFILE=-fMakefile.libretro
# #make CONSOLE=2048       CORE=cores/libretro-2048 MAKEFILE=-fMakefile.libretro
# echo "-- gong make --"
# make clean CONSOLE=gong       CORE=cores/gong MAKEFILE=-fMakefile.libretro
# make CONSOLE=gong       CORE=cores/gong MAKEFILE=-fMakefile.libretro
# echo "-- outrun make --"
# make clean CONSOLE=outrun     CORE=cores/cannonball
# make CONSOLE=outrun     CORE=cores/cannonball
# echo "-- wolf3d make --"
# make clean CONSOLE=wolf3d     CORE=cores/ecwolf/src/libretro
# make CONSOLE=wolf3d     CORE=cores/ecwolf/src/libretro
# echo "-- prboom make --"
# make clean CONSOLE=prboom     CORE=cores/libretro-prboom
# make CONSOLE=prboom     CORE=cores/libretro-prboom
# echo "-- flashback make --"
# make clean CONSOLE=flashback  CORE=cores/REminiscence
# make CONSOLE=flashback  CORE=cores/REminiscence
# echo "-- xrick make --"
# make clean CONSOLE=xrick      CORE=cores/libretro-xrick
# make CONSOLE=xrick      CORE=cores/libretro-xrick
# echo "-- gw make --"
# make clean CONSOLE=gw         CORE=cores/libretro-gw
# make CONSOLE=gw         CORE=cores/libretro-gw
# echo "-- cdg make --"
# make clean CONSOLE=cdg        CORE=cores/libretro-pocketcdg
# make CONSOLE=cdg        CORE=cores/libretro-pocketcdg
# echo "-- int make --"
# make clean CONSOLE=int        CORE=cores/FreeIntv
# make CONSOLE=int        CORE=cores/FreeIntv
# echo "-- msx make --"
# make clean CONSOLE=msx        CORE=cores/libretro-blueMSX
# make CONSOLE=msx        CORE=cores/libretro-blueMSX
# echo "-- gme make --"
# make clean CONSOLE=gme        CORE=cores/libretro-gme
# make CONSOLE=gme        CORE=cores/libretro-gme
# echo "-- pce make --"
# make clean CONSOLE=pce        CORE=cores/libretro-beetle-pce-fast
# make CONSOLE=pce        CORE=cores/libretro-beetle-pce-fast
# echo "-- ngpc make --"
# make clean CONSOLE=ngpc       CORE=cores/RACE
# make CONSOLE=ngpc       CORE=cores/RACE
# echo "-- gba make --"
# make clean CONSOLE=gba        CORE=cores/gpsp
# make CONSOLE=gba        CORE=cores/gpsp
# echo "-- dblcherryGB make --"
# make clean CONSOLE=dblcherrygb  CORE=cores/libretro-doublecherryGB
# make CONSOLE=dblcherrygb  CORE=cores/libretro-doublecherryGB
echo "-- gb make --"
make clean CONSOLE=gb  CORE=cores/libretro-gambatte
make CONSOLE=gb        CORE=cores/libretro-gambatte
# echo "-- gbgb make --"
# make clean CONSOLE=gbgb       CORE=cores/Gearboy/platforms/libretro
# make CONSOLE=gbgb       CORE=cores/Gearboy/platforms/libretro
# echo "-- gbb make --"
# make clean CONSOLE=gbb         CORE=cores/libretro-tgbdual
# make CONSOLE=gbb         CORE=cores/libretro-tgbdual
# echo "-- nes make --"
# make clean CONSOLE=nes        CORE=cores/libretro-fceumm
# make CONSOLE=nes        CORE=cores/libretro-fceumm
# echo "-- nesq make --"
# make clean CONSOLE=nesq       CORE=cores/QuickNES_Core
# make CONSOLE=nesq       CORE=cores/QuickNES_Core
# echo "-- pokem make --"
# make clean CONSOLE=pokem      CORE=cores/PokeMini
# make CONSOLE=pokem      CORE=cores/PokeMini
# echo "-- snes02 make --"
# make clean CONSOLE=snes02     CORE=cores/snes9x2002
# make CONSOLE=snes02     CORE=cores/snes9x2002
# echo "-- snes make --"
# make clean CONSOLE=snes       CORE=cores/snes9x2005
# make CONSOLE=snes       CORE=cores/snes9x2005
# echo "-- sega make --"
# make clean CONSOLE=sega       CORE=cores/picodrive MAKEFILE=-fMakefile.libretro
# make CONSOLE=sega       CORE=cores/picodrive MAKEFILE=-fMakefile.libretro
# echo "-- gg make --"
# make clean CONSOLE=gg         CORE=cores/Gearsystem/platforms/libretro
# make CONSOLE=gg         CORE=cores/Gearsystem/platforms/libretro
# echo "-- zx81 make --"
# make clean CONSOLE=zx81       CORE=cores/libretro-81
# make CONSOLE=zx81       CORE=cores/libretro-81
# echo "-- spec make --"
# make clean CONSOLE=spec       CORE=cores/libretro-fuse
# make CONSOLE=spec       CORE=cores/libretro-fuse
# echo "-- thom make --"
# make clean CONSOLE=thom       CORE=cores/theodore
# make CONSOLE=thom       CORE=cores/theodore
# echo "-- vec make --"
# make clean CONSOLE=vec        CORE=cores/libretro-vecx
# make CONSOLE=vec        CORE=cores/libretro-vecx
# echo "-- wsv make --"
# make clean CONSOLE=wsv        CORE=cores/potator/platform/libretro
# make CONSOLE=wsv        CORE=cores/potator/platform/libretro

# #working but issues
# echo "-- amstrad make --"
# make clean CONSOLE=amstrad    CORE=cores/libretro-crocods
# make CONSOLE=amstrad    CORE=cores/libretro-crocods
# echo "-- arduboy make --"
# make clean CONSOLE=arduboy    CORE=cores/arduous
# make CONSOLE=arduboy    CORE=cores/arduous
# echo "-- lnxb make --"
# make clean CONSOLE=lnxb       CORE=cores/libretro-beetle-lynx
# make CONSOLE=lnxb       CORE=cores/libretro-beetle-lynx
# echo "-- bk make --"
# #make clean CONSOLE=bk         CORE=cores/bk-emulator MAKEFILE=-fMakefile.libretro
# #make CONSOLE=bk         CORE=cores/bk-emulator MAKEFILE=-fMakefile.libretro
# echo "-- c64sc make --"
# make clean CONSOLE=c64sc   CORE=cores/libretro-vice EMUTYPE=x64sc
# echo "-- c64sc make --"
# make CONSOLE=c64sc         CORE=cores/libretro-vice EMUTYPE=x64sc
# echo "-- c64sc make --"
# make clean CONSOLE=c64sc   CORE=cores/libretro-vice EMUTYPE=x64sc
# echo "-- c64 make --"
# make clean CONSOLE=c64     CORE=cores/libretro-vice EMUTYPE=x64
# echo "-- c64 make --"
# make CONSOLE=c64           CORE=cores/libretro-vice EMUTYPE=x64
# echo "-- c64 make --"
# make clean CONSOLE=c64     CORE=cores/libretro-vice EMUTYPE=x64
# echo "-- c64f make --"
make clean CONSOLE=c64f  CORE=cores/libretro-frodo EMUTYPE=frodo
make CONSOLE=c64f  CORE=cores/libretro-frodo platform=sf2000 EMUTYPE=frodo
# echo "-- c64f make --"
# make clean CONSOLE=c64f        CORE=cores/libretro-frodo EMUTYPE=frodo
# make CONSOLE=c64f        CORE=cores/libretro-frodo platform=sf2000 EMUTYPE=frodo
# echo "-- c64f make --"
# make clean CONSOLE=c64f  CORE=cores/libretro-frodo EMUTYPE=frodo
# echo "-- c64fc make --"
# make clean CONSOLE=c64fc CORE=cores/libretro-frodo EMUTYPE=frodosc
# echo "-- c64fc make --"
# make CONSOLE=c64fc       CORE=cores/libretro-frodo EMUTYPE=frodosc
# echo "-- c64fc make --"
# make clean CONSOLE=c64fc CORE=cores/libretro-frodo EMUTYPE=frodosc
# echo "-- vic20 make --"
# make clean CONSOLE=vic20   CORE=cores/libretro-vice EMUTYPE=xvic
# echo "-- vic20 make --"
# make CONSOLE=vic20         CORE=cores/libretro-vice EMUTYPE=xvic
# echo "-- vic20 make --"
# make clean CONSOLE=vic20   CORE=cores/libretro-vice EMUTYPE=xvic
# echo "-- fake08 make --"
# make clean CONSOLE=fake08     CORE=cores/fake-08/platform/libretro
# make CONSOLE=fake08     CORE=cores/fake-08/platform/libretro
# echo "-- lowres-nx make --"
# make clean CONSOLE=lowres-nx  CORE=cores/lowres-nx/platform/LibRetro
# make CONSOLE=lowres-nx  CORE=cores/lowres-nx/platform/LibRetro
# echo "-- mrboom make --"
# #make clean CONSOLE=mrboom     CORE=cores/libretro-mrboom
# #make CONSOLE=mrboom     CORE=cores/libretro-mrboom
# echo "-- jnb make --"
# make clean CONSOLE=jnb        CORE=cores/libretro-jumpnbump
# make CONSOLE=jnb        CORE=cores/libretro-jumpnbump
# echo "-- cavestory make --"
# make clean CONSOLE=cavestory  CORE=cores/libretro-nxengine
# make CONSOLE=cavestory  CORE=cores/libretro-nxengine
# echo "-- x48 make --"
# #make clean CONSOLE=x48        CORE=cores/libretro-x48
# #make CONSOLE=x48        CORE=cores/libretro-x48
# echo "-- o2em make --"
# make clean CONSOLE=o2em       CORE=cores/libretro-o2em
# make CONSOLE=o2em       CORE=cores/libretro-o2em
# echo "-- pcesgx make --"
# make clean CONSOLE=pcesgx     CORE=cores/libretro-beetle-supergrafx
# make CONSOLE=pcesgx     CORE=cores/libretro-beetle-supergrafx
# echo "-- pc8800 make --"
# make clean CONSOLE=pc8800     CORE=cores/libretro-quasi88
# make CONSOLE=pc8800     CORE=cores/libretro-quasi88
# echo "-- pcfx make --"
# make clean CONSOLE=pcfx       CORE=cores/libretro-beetle-pcfx
# make CONSOLE=pcfx       CORE=cores/libretro-beetle-pcfx
# echo "-- gbav make --"
# make clean CONSOLE=gbav       CORE=cores/vba-next
# make CONSOLE=gbav       CORE=cores/vba-next
# echo "-- mgba make --"
# make clean CONSOLE=mgba       CORE=cores/mgba
# make CONSOLE=mgba       CORE=cores/mgba
# echo "-- nest make --"
# make clean CONSOLE=nest       CORE=cores/nestopia/libretro
# make CONSOLE=nest       CORE=cores/nestopia/libretro
# echo "-- vb make --"
# make clean CONSOLE=vb         CORE=cores/libretro-beetle-vb
# make CONSOLE=vb         CORE=cores/libretro-beetle-vb
# echo "-- gpgx make --"
# make clean CONSOLE=gpgx       CORE=cores/Genesis-Plus-GX MAKEFILE=-fMakefile.libretro
# make CONSOLE=gpgx       CORE=cores/Genesis-Plus-GX MAKEFILE=-fMakefile.libretro
# echo "-- geolith make --"
# make clean CONSOLE=geolith    CORE=cores/libretro-geolith/libretro
# make CONSOLE=geolith    CORE=cores/libretro-geolith/libretro
# echo "-- xmil make --"
# make clean CONSOLE=xmil       CORE=cores/libretro-xmil/libretro
# make CONSOLE=xmil       CORE=cores/libretro-xmil/libretro
# #working but major issues, not to release
# #make -C cores/fbalpha2012/svn-current/trunk platform=sf2000 -fmakefile.libretro generate-files && make CONSOLE=fba CORE=cores/fbalpha2012/svn-current/trunk MAKEFILE=-fmakefile.libretro
# #make CONSOLE=mame2003   CORE=cores/libretro-mame2003-plus
# #make CONSOLE=mame2003mw CORE=cores/mame2003_midway
# #make CONSOLE=atarist    CORE=cores/hatari MAKEFILE=-fMakefile.libretro
# echo "-- quake make --"
# make clean CONSOLE=quake      CORE=cores/tyrquake
# make CONSOLE=quake      CORE=cores/tyrquake

#test cores
# make clean CONSOLE=testadv CORE=cores/libretro-samples/tests/test_advanced
# make CONSOLE=testadv CORE=cores/libretro-samples/tests/test_advanced
# make clean CONSOLE=testwav CORE=cores/libretro-samples/audio/audio_playback_wav
# make CONSOLE=testwav CORE=cores/libretro-samples/audio/audio_playback_wav

#deprecated working
#
#make clean CONSOLE=tennis     CORE=cores/retro-tennis
#make CONSOLE=tennis     CORE=cores/retro-tennis
#

make clean CONSOLE=js2000        CORE=cores/js2000
make CONSOLE=js2000        CORE=cores/js2000 && \

# make updatelogo ALPHARELEASE=0.10
true