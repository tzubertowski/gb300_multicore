#!/bin/bash
dos2unix buildcoresworking.sh
dos2unix cleancoresworking.sh

# TODO: move into separate repo with assets, shouldn't be there rly
cp -r assets/os/bisrv.asd bisrv_08_03.asd

rm -rf sdcard
./cleancoresworking.sh
./buildcoresworking.sh
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/cores/config

mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/amstradb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/m2k
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/a26
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/a5200
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/a78
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/a800
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/lnx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/wswan
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/chip8
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/col
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/fcf
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/retro8
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/vapor
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/2048
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gong
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/outrun
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/wolf3d
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/prboom
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/flashback
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/xrick
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gw
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/cdg
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/int
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/msx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gme
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/pce
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/ngpc
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gba
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/dblcherrygb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gbgb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gbb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/nes
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/nesq
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/pokem
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/snes02
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/snes
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/sega
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gg
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/zx81
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/spec
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/thom
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/vec
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/wsv
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/amstrad
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/arduboy
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/nxb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/bk
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/c64sc
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/c64
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/c64f
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/c64fc
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/vic20
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/fake08
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/lowres-nx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/mrboom
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/jnb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/cavestory
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/x48
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/o2em
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/pcesgx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/pc8800
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/pcfx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gbav
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/mgba
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/nest
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/vb
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/gpgx
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/geolith
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/xmil
mkdir -p /__w/gb300_multicore/gb300_multicore/sdcard/roms/quake

cp -r assets/coreconfig/* /__w/gb300_multicore/gb300_multicore/sdcard/cores/config

tar -czvf /__w/gb300_multicore/gb300_multicore/gb300-multicore-canary.tar.gz /__w/gb300_multicore/gb300_multicore/sdcard