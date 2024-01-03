#!/bin/bash

PROJ_DIR=$HOME/proj64

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$HOME/proj64/CGAL-4.14.3/ \
      -DCMAKE_BUILD_TYPE="Release" \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_CXX_FLAGS="-std=c++14" \
      -DBOOST_ROOT=$PROJ_DIR/boost_1_84/ \
      -DWITH_CGAL_Qt5=OFF \
      -DWITH_CGAL_ImageIO=OFF \
      -DCGAL_DISABLE_GMP=TRUE \
      -DBUILD_SHARED_LIBS=FALSE


