#!/bin/bash

set -eux

VER=0.0.1
BUNDLE_DIR=$HOME/proj64/cuemol2_bundle_${VER}
POVRAY_SRC=$HOME/proj64/povray_bundleb/

######

POVRAY_DIR=$BUNDLE_DIR/povray/
rm -rf $POVRAY_DIR

mkdir -p $POVRAY_DIR/bin/
cp -v $POVRAY_SRC/bin/povray $POVRAY_DIR/bin/

mkdir -p $POVRAY_DIR/include/
cp -v $POVRAY_SRC/share/povray-3.7/include/*  $POVRAY_DIR/include
