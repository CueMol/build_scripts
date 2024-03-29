#!/bin/sh

set -eux

# BUILD_TYPE=Debug
BUILD_TYPE=Release

PYTHON=python3
PYTHON_ROOT=$($PYTHON -c 'import sys;import pathlib; print(pathlib.Path(sys.executable).parent.parent)')
echo "PYTHON_ROOT=$PYTHON_ROOT"

BUILD_PYTHON_BINDINGS=OFF
BUILD_PYTHON_MODULE=OFF

# Install location
CMAKE_INSTALL_PREFIX=$HOME/tmp/cuemol2

# Prerequisites
PROJ_DIR=$HOME/proj64
CMAKE_PREFIX_PATH="$PROJ_DIR"

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX \
      -DCMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH \
      -DBoost_ROOT=$PROJ_DIR/boost_1_84/ \
      -DFFTW_ROOT=$PROJ_DIR/fftw-3.3.10 \
      -DLCMS2_ROOT=$PROJ_DIR/lcms2-2.15 \
      -DGLEW_ROOT=$PROJ_DIR/glew-2.1.0 \
      -DBUILD_PYTHON_BINDINGS=$BUILD_PYTHON_BINDINGS \
      -DBUILD_PYTHON_MODULE=$BUILD_PYTHON_MODULE \
      -DPython3_ROOT_DIR=$PYTHON_ROOT \
      -DBUILD_XPCJS_BINDINGS=ON \
      -DCGAL_DO_NOT_WARN_ABOUT_CMAKE_BUILD_TYPE=TRUE \
      -DCMAKE_BUILD_TYPE=$BUILD_TYPE \


#      -DQt5_DIR=/usr/local/opt/qt5/lib/cmake/Qt5 \
#      -G "Xcode" \
#      -DGLEW_INCLUDE_DIRS=$PROJ_DIR/glew-2.1.0 \
