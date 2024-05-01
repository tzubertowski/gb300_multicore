#!/bin/bash
dos2unix buildcoresworking.sh
dos2unix cleanandbuildworking.sh
dos2unix buildgpspdynarec.sh
rm -rf sdcard
./cleancoresworking.sh
./buildcoresworking.sh

tar -czvf /__w/gb300_multicore/gb300_multicore/gb300-multicore-canary.tar.gz /__w/gb300_multicore/gb300_multicore/sdcard