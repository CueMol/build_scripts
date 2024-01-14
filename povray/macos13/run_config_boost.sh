#!/bin/sh
instpath=$HOME/proj64/povray/boost_1_76_static

./b2 \
 --prefix=$instpath \
 --with-date_time \
 --with-filesystem \
 --with-iostreams \
 --with-system \
 --with-thread \
 --with-chrono \
 --with-timer \
link=static threading=multi install
