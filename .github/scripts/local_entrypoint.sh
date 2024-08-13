#!/bin/bash
dos2unix buildcoresworking.sh
dos2unix cleancoresworking.sh

# TODO: move into separate repo with assets, shouldn't be there rly
cp -r assets/os/bisrv.asd bisrv_08_03.asd

rm -rf sdcard
./cleancoresworking.sh
./buildcoresworking.sh
mkdir -p sdcard/cores/config

cp -r assets/coreconfig/* sdcard/cores/config

mkdir -p sdcard/roms/amstradb
mkdir -p sdcard/roms/m2k
mkdir -p sdcard/roms/a26
mkdir -p sdcard/roms/a5200
mkdir -p sdcard/roms/a78
mkdir -p sdcard/roms/a800
mkdir -p sdcard/roms/lnx
mkdir -p sdcard/roms/wswan
mkdir -p sdcard/roms/chip8
mkdir -p sdcard/roms/col
mkdir -p sdcard/roms/fcf
mkdir -p sdcard/roms/retro8
mkdir -p sdcard/roms/vapor
mkdir -p sdcard/roms/2048
mkdir -p sdcard/roms/gong
mkdir -p sdcard/roms/outrun
mkdir -p sdcard/roms/wolf3d
mkdir -p sdcard/roms/prboom
mkdir -p sdcard/roms/flashback
mkdir -p sdcard/roms/xrick
mkdir -p sdcard/roms/gw
mkdir -p sdcard/roms/cdg
mkdir -p sdcard/roms/int
mkdir -p sdcard/roms/msx
mkdir -p sdcard/roms/gme
mkdir -p sdcard/roms/pce
mkdir -p sdcard/roms/ngpc
mkdir -p sdcard/roms/gba
mkdir -p sdcard/roms/dblcherrygb
mkdir -p sdcard/roms/gb
mkdir -p sdcard/roms/gbgb
mkdir -p sdcard/roms/gbb
mkdir -p sdcard/roms/nes
mkdir -p sdcard/roms/nesq
mkdir -p sdcard/roms/pokem
mkdir -p sdcard/roms/snes02
mkdir -p sdcard/roms/snes
mkdir -p sdcard/roms/sega
mkdir -p sdcard/roms/gg
mkdir -p sdcard/roms/zx81
mkdir -p sdcard/roms/spec
mkdir -p sdcard/roms/thom
mkdir -p sdcard/roms/vec
mkdir -p sdcard/roms/wsv
mkdir -p sdcard/roms/amstrad
mkdir -p sdcard/roms/arduboy
mkdir -p sdcard/roms/nxb
mkdir -p sdcard/roms/bk
mkdir -p sdcard/roms/c64sc
mkdir -p sdcard/roms/c64
mkdir -p sdcard/roms/c64f
mkdir -p sdcard/roms/c64fc
mkdir -p sdcard/roms/vic20
mkdir -p sdcard/roms/fake08
mkdir -p sdcard/roms/lowres-nx
mkdir -p sdcard/roms/mrboom
mkdir -p sdcard/roms/jnb
mkdir -p sdcard/roms/cavestory
mkdir -p sdcard/roms/x48
mkdir -p sdcard/roms/o2em
mkdir -p sdcard/roms/pcesgx
mkdir -p sdcard/roms/pc8800
mkdir -p sdcard/roms/pcfx
mkdir -p sdcard/roms/gbav
mkdir -p sdcard/roms/mgba
mkdir -p sdcard/roms/nest
mkdir -p sdcard/roms/vb
mkdir -p sdcard/roms/gpgx
mkdir -p sdcard/roms/geolith
mkdir -p sdcard/roms/xmil
mkdir -p sdcard/roms/quake

tar -czvf gb300-multicore-canary.tar.gz sdcard