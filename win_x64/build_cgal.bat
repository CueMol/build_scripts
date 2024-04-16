REM wget "https://github.com/CGAL/cgal/releases/download/releases%%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz"
tar xJf CGAL-4.14.3.tar.xz
cd CGAL-4.14.3

SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\CGAL-4.14.3

mkdir -p build

cmake -S . -B build ^
 -DCMAKE_INSTALL_PREFIX=%INSTPATH% ^
 -DCMAKE_BUILD_TYPE="Release" ^
 -DBOOST_ROOT=%DEPLIBS_DIR%\boost_1_84_0 ^
 -DWITH_CGAL_Qt5=OFF ^
 -DWITH_CGAL_ImageIO=OFF ^
 -DCGAL_DISABLE_GMP=TRUE ^
 -DBUILD_SHARED_LIBS=FALSE

REM  -DCMAKE_CXX_FLAGS="-std=c++14"

cmake --build build --config Release
cmake --install build --config Release

cd ..
