#!/bin/bash
dos2unix buildcoresworking.sh
dos2unix cleanandbuildworking.sh
dos2unix buildgpspdynarec.sh
rm -rf sdcard
./cleancoresworking.sh
./buildcoresworking.sh

tar -czvf gb300-multicore.tar.gz sdcard