#!/bin/sh

# Install location
CMAKE_INSTALL_PREFIX=$HOME/tmp

# Prerequisites
PROJ_DIR=$HOME/proj64
CMAKE_PREFIX_PATH="$PROJ_DIR"

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX \
      -DCMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH \
      -DLIBCUEMOL2_ROOT=$HOME/tmp \
      -DBUILD_PYTHON_BINDINGS=$BUILD_PYTHON_BINDINGS \
      -DCGAL_DO_NOT_WARN_ABOUT_CMAKE_BUILD_TYPE=TRUE


      # -DFFTW_ROOT=$HOME/proj64_cmake/fftw
#      -DQt5_DIR=/usr/local/opt/qt5/lib/cmake/Qt5 \
#      -G "Xcode" \
#      -DGLEW_INCLUDE_DIRS=$PROJ_DIR/glew-2.1.0 \
