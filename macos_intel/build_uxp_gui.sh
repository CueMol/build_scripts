#!/bin/bash

set -eux

FFMPEG_DIST=ffmpeg61intel

BUNDLE_DIR=$(pwd)/cuemol2_bundle
mkdir -p $BUNDLE_DIR
pushd $BUNDLE_DIR
# Retrieve povray prebuild binary
wget -c https://github.com/CueMol/povray_build/releases/download/v0.0.5/povray_macOS_X64.tar.bz2
xattr -cr povray_macOS_X64.tar.bz2
tar xjvf povray_macOS_X64.tar.bz2
# Retrieve ffmpeg macos/intel bin
# wget -c https://www.osxexperts.net/${FFMPEG_DIST}.zip
xattr -cr ${FFMPEG_DIST}.zip
mkdir -p ffmpeg/bin
cd ffmpeg/bin
unzip -o ../../${FFMPEG_DIST}.zip
popd

TARGET_DIR=${1:-.}
SCRIPT_DIR=$(cd $(dirname $0); pwd)
echo SCRIPT_DIR: $SCRIPT_DIR
echo TARGET_DIR: $TARGET_DIR

sed "s!@CUEMOL_BUNDLE@!$BUNDLE_DIR!g" $SCRIPT_DIR/mozconfig > $TARGET_DIR/.mozconfig

pushd $TARGET_DIR
./mach build
./mach package
popd
