#!/bin/bash
set -eux
TMPDIR=$HOME/tmp/tmp
VER=0.0.1
BUNDLE_DIR=$HOME/proj64/cuemol2_bundle_${VER}
FFMPEG_DIST=ffmpeg61intel

##########

mkdir -p $TMPDIR
cd $TMPDIR
# Wget ffmpeg macos/arm64 bin
# wget https://www.osxexperts.net/${FFMPEG_DIST}.zip

mkdir -p $FFMPEG_DIST
cd $FFMPEG_DIST
unzip -o ../${FFMPEG_DIST}.zip
# xattr -p com.apple.quarantine ffmpeg
# xattr -d com.apple.quarantine ffmpeg

FFMPEG_DIR=$BUNDLE_DIR/ffmpeg/
rm -rf $FFMPEG_DIR
mkdir -p $FFMPEG_DIR/bin/
cp -v ffmpeg $FFMPEG_DIR/bin/

cd ..
rm -rf $FFMPEG_DIST
