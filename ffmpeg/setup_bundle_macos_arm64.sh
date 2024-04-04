#!/bin/bash

set -eux

VER=0.0.1
BUNDLE_DIR=$HOME/proj64/cuemol2_bundle_${VER}

FFMPEG_DIST=ffmpeg61arm

# TODO: Wget ffmpeg macos/arm64 bin
# wget https://www.osxexperts.net/${FFMPEG_DIST}.zip

mkdir $FFMPEG_DIST
cd $FFMPEG_DIST
unzip ../${FFMPEG_DIST}.zip
xattr -p com.apple.quarantine ffmpeg
xattr -d com.apple.quarantine ffmpeg

FFMPEG_DIR=$BUNDLE_DIR/ffmpeg/
rm -rf $FFMPEG_DIR
mkdir -p $FFMPEG_DIR/bin/
cp -v ffmpeg $FFMPEG_DIR/bin/
