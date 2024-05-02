#!/bin/bash
dos2unix buildcoresworking.sh
dos2unix cleanandbuildworking.sh
dos2unix buildgpspdynarec.sh

# TODO: move into separate repo with assets, shouldn't be there rly
cp -r assets/os/bisrv.asd bisrv_08_03.asd

rm -rf sdcard
./cleancoresworking.sh
./buildcoresworking.sh

tar -czvf /__w/gb300_multicore/gb300_multicore/gb300-multicore-canary.tar.gz /__w/gb300_multicore/gb300_multicore/sdcard