#!/bin/sh
instpath=$HOME/proj64/boost_1_84

./b2 \
 --prefix=$instpath \
 --with-date_time \
 --with-filesystem \
 --with-iostreams \
 --with-system \
 --with-thread \
 --with-chrono \
 --with-timer \
link=shared threading=multi install

# architecture=x86 address-model=64 
# --exec-prefix=$instpath \
# --libdir=$instpath \
# --includedir=$instpath \
