#!/bin/bash

instpath=$HOME/proj64/povray_bundleb

./configure \
    NON_REDISTRIBUTABLE_BUILD=yes \
    COMPILED_BY="your name <email@address>" \
    --prefix=$instpath \
    --with-boost=$HOME/proj64/povray_bundle/boost_1_76_static \
    --with-libpng=$HOME/proj64/povray_bundle/libpng12/lib \
    --without-libjpeg \
    --without-libtiff

