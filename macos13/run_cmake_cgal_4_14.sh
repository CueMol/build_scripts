#!/bin/bash

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$HOME/proj64/CGAL-4.14.3/ \
      -DCMAKE_BUILD_TYPE="Release" \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_CXX_FLAGS="-std=c++14" \
      -DWITH_CGAL_Qt5=OFF \
      -DWITH_CGAL_ImageIO=OFF \
      -DCGAL_DISABLE_GMP=TRUE

