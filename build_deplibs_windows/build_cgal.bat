echo on

REM Common Setup
if "%1"=="" (
   echo "arg1 not specified"
   exit /b   
)
SET BASEDIR=%1

SET TMPDIR=%BASEDIR%\tmp

mkdir %TMPDIR%
cd %TMPDIR%

SET CGAL_VER=6.1
SET BOOST_VER=1_84_0

wget --content-disposition -c --progress=dot:mega ^
     https://github.com/CGAL/cgal/releases/download/v%CGAL_VER%/CGAL-%CGAL_VER%.tar.xz

REM     https://github.com/CGAL/cgal/releases/download/releases%%2F%CGAL_VER%/%CGAL_VER%.tar.xz

tar xJf CGAL-%CGAL_VER%.tar.xz
cd CGAL-%CGAL_VER%

SET DEPLIBS_DIR=%BASEDIR%
SET INSTPATH=%DEPLIBS_DIR%\CGAL-%CGAL_VER%

mkdir build

cmake -S . -B build ^
 -DCMAKE_INSTALL_PREFIX=%INSTPATH% ^
 -DCMAKE_BUILD_TYPE="Release" ^
 -DBOOST_ROOT=%DEPLIBS_DIR%\boost_%BOOST_VER% ^
 -DWITH_CGAL_Qt5=OFF ^
 -DWITH_CGAL_ImageIO=OFF ^
 -DCGAL_DISABLE_GMP=TRUE ^
 -DCGAL_HEADER_ONLY=TRUE ^
 -DBUILD_SHARED_LIBS=FALSE

REM  -DCMAKE_CXX_FLAGS="-std=c++14"

cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release

dir %INST_PATH%

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%

