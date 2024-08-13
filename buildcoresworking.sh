#!/bin/bash

#fully working
# echo "-- Amstradb make --"
# make CONSOLE=amstradb   CORE=cores/libretro-cap32
# echo "-- m2k make --"
# make CONSOLE=m2k        CORE=cores/libretro-mame2000
# echo "-- a26 make --"
# make CONSOLE=a26        CORE=cores/libretro-stella2014
# echo "-- a5200 make --"
# make CONSOLE=a5200      CORE=cores/a5200
# echo "-- a78 make --"
# make CONSOLE=a78        CORE=cores/libretro-prosystem
# echo "-- a800 make --"
# make CONSOLE=a800       CORE=cores/libretro-atari800lib
# echo "-- lnx make --"
# make CONSOLE=lnx        CORE=cores/libretro-handy
# echo "-- wswan make --"
# make CONSOLE=wswan      CORE=cores/libretro-beetle-wswan
# echo "-- chip8 make --"
# make CONSOLE=chip8      CORE=cores/jaxe MAKEFILE=-fMakefile.libretro
# echo "-- col make --"
# make CONSOLE=col        CORE=cores/Gearcoleco/platforms/libretro
# echo "-- fcf make --"
# make CONSOLE=fcf        CORE=cores/FreeChaF
# echo "-- retro8 make --"
# make CONSOLE=retro8     CORE=cores/retro8
# echo "-- vapor make --"
# make CONSOLE=vapor      CORE=cores/vaporspec/machine MAKEFILE=-fMakefile.libretro
# echo "-- 2048 make --"
# #make CONSOLE=2048       CORE=cores/libretro-2048 MAKEFILE=-fMakefile.libretro
# echo "-- gong make --"
# make CONSOLE=gong       CORE=cores/gong MAKEFILE=-fMakefile.libretro
# echo "-- outrun make --"
# make CONSOLE=outrun     CORE=cores/cannonball
# echo "-- wolf3d make --"
# make CONSOLE=wolf3d     CORE=cores/ecwolf/src/libretro
# echo "-- prboom make --"
# make CONSOLE=prboom     CORE=cores/libretro-prboom
# echo "-- flashback make --"
# make CONSOLE=flashback  CORE=cores/REminiscence
# echo "-- xrick make --"
# make CONSOLE=xrick      CORE=cores/libretro-xrick
# echo "-- gw make --"
# make CONSOLE=gw         CORE=cores/libretro-gw
# echo "-- cdg make --"
# make CONSOLE=cdg        CORE=cores/libretro-pocketcdg
# echo "-- int make --"
# make CONSOLE=int        CORE=cores/FreeIntv
# echo "-- msx make --"
# make CONSOLE=msx        CORE=cores/libretro-blueMSX
# echo "-- gme make --"
# make CONSOLE=gme        CORE=cores/libretro-gme
# echo "-- pce make --"
# make CONSOLE=pce        CORE=cores/libretro-beetle-pce-fast
# echo "-- ngpc make --"
# make CONSOLE=ngpc       CORE=cores/RACE
echo "-- gba make --"
make CONSOLE=gba        CORE=cores/gpsp
# echo "-- dblcherryGB make --"
# make CONSOLE=dblcherrygb  CORE=cores/libretro-doublecherryGB
# echo "-- gb make --"
# make CONSOLE=gb        CORE=cores/libretro-gambatte
# echo "-- gbgb make --"
# make CONSOLE=gbgb       CORE=cores/Gearboy/platforms/libretro
# echo "-- gbb make --"
# make CONSOLE=gbb         CORE=cores/libretro-tgbdual
# echo "-- nes make --"
# make CONSOLE=nes        CORE=cores/libretro-fceumm
# echo "-- nesq make --"
# make CONSOLE=nesq       CORE=cores/QuickNES_Core
# echo "-- pokem make --"
# make CONSOLE=pokem      CORE=cores/PokeMini
# echo "-- snes02 make --"
# make CONSOLE=snes02     CORE=cores/snes9x2002
# echo "-- snes make --"
# make CONSOLE=snes       CORE=cores/snes9x2005
# echo "-- sega make --"
# make CONSOLE=sega       CORE=cores/picodrive MAKEFILE=-fMakefile.libretro
# echo "-- gg make --"
# make CONSOLE=gg         CORE=cores/Gearsystem/platforms/libretro
# echo "-- zx81 make --"
# make CONSOLE=zx81       CORE=cores/libretro-81
# echo "-- spec make --"
# make CONSOLE=spec       CORE=cores/libretro-fuse
# echo "-- thom make --"
# make CONSOLE=thom       CORE=cores/theodore
# echo "-- thom make --"
# make CONSOLE=vec        CORE=cores/libretro-vecx
# echo "-- wsv make --"
# make CONSOLE=wsv        CORE=cores/potator/platform/libretro

# #working but issues
# echo "-- amstrad make --"
# make CONSOLE=amstrad    CORE=cores/libretro-crocods
# echo "-- arduboy make --"
# make CONSOLE=arduboy    CORE=cores/arduous
# echo "-- lnxb make --"
# make CONSOLE=lnxb       CORE=cores/libretro-beetle-lynx
# echo "-- bk make --"
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
# make clean CONSOLE=c64f  CORE=cores/libretro-frodo EMUTYPE=frodo
# echo "-- c64f make --"
# make CONSOLE=c64f        CORE=cores/libretro-frodo EMUTYPE=frodo
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
# make CONSOLE=fake08     CORE=cores/fake-08/platform/libretro
# echo "-- lowres-nx make --"
# make CONSOLE=lowres-nx  CORE=cores/lowres-nx/platform/LibRetro
# echo "-- mrboom make --"
# #make CONSOLE=mrboom     CORE=cores/libretro-mrboom
# echo "-- jnb make --"
# make CONSOLE=jnb        CORE=cores/libretro-jumpnbump
# echo "-- cavestory make --"
# make CONSOLE=cavestory  CORE=cores/libretro-nxengine
# echo "-- x48 make --"
# #make CONSOLE=x48        CORE=cores/libretro-x48
# echo "-- o2em make --"
# make CONSOLE=o2em       CORE=cores/libretro-o2em
# echo "-- pcesgx make --"
# make CONSOLE=pcesgx     CORE=cores/libretro-beetle-supergrafx
# echo "-- pc8800 make --"
# make CONSOLE=pc8800     CORE=cores/libretro-quasi88
# echo "-- pcfx make --"
# make CONSOLE=pcfx       CORE=cores/libretro-beetle-pcfx
# echo "-- gbav make --"
# make CONSOLE=gbav       CORE=cores/vba-next
# echo "-- mgba make --"
# make CONSOLE=mgba       CORE=cores/mgba
# echo "-- nest make --"
# make CONSOLE=nest       CORE=cores/nestopia/libretro
# echo "-- vb make --"
# make CONSOLE=vb         CORE=cores/libretro-beetle-vb
# echo "-- gpgx make --"
# make CONSOLE=gpgx       CORE=cores/Genesis-Plus-GX MAKEFILE=-fMakefile.libretro
# echo "-- geolith make --"
# make CONSOLE=geolith    CORE=cores/libretro-geolith/libretro
# echo "-- xmil make --"
# make CONSOLE=xmil       CORE=cores/libretro-xmil/libretro
# #working but major issues, not to release
# #make -C cores/fbalpha2012/svn-current/trunk platform=sf2000 -fmakefile.libretro generate-files && make CONSOLE=fba CORE=cores/fbalpha2012/svn-current/trunk MAKEFILE=-fmakefile.libretro
# #make CONSOLE=mame2003   CORE=cores/libretro-mame2003-plus
# #make CONSOLE=mame2003mw CORE=cores/mame2003_midway
# #make CONSOLE=atarist    CORE=cores/hatari MAKEFILE=-fMakefile.libretro
# echo "-- quake make --"
# make CONSOLE=quake      CORE=cores/tyrquake

#test cores
# make CONSOLE=testadv CORE=cores/libretro-samples/tests/test_advanced
# make CONSOLE=testwav CORE=cores/libretro-samples/audio/audio_playback_wav

#deprecated working
#
#make CONSOLE=tennis     CORE=cores/retro-tennis
#


# make updatelogo ALPHARELEASE=0.10
true