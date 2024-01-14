#!/bin/bash

instpath=$HOME/proj64/povray/

./configure \
    NON_REDISTRIBUTABLE_BUILD=yes \
    COMPILED_BY="your name <email@address>" \
    --prefix=$instpath \
    --with-boost=$HOME/proj64/povray/boost_1_76_static \
    --with-libpng=$HOME/proj64/povray/libpng12/lib \
    --without-libjpeg \
    --without-libtiff

