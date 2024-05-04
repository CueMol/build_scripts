echo on

REM Common Setup
if "%1"=="" (
   echo "arg1 not specified"
   exit /b   
)
SET BASEDIR=%1
SET RUNNER_OS=%2
SET RUNNER_ARCH=%3
SET TMPDIR=%BASEDIR%\tmp

mkdir %TMPDIR%
cd %TMPDIR%

SET CGAL_VER=CGAL-4.14.3
SET BOOST_VER=boost_1_84_0

wget --content-disposition -c --progress=dot:mega ^
     https://github.com/CGAL/cgal/releases/download/releases%%2F%CGAL_VER%/%CGAL_VER%.tar.xz
tar xJf %CGAL_VER%.tar.xz
cd %CGAL_VER%

SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\%CGAL_VER%

mkdir -p build

cmake -S . -B build ^
 -DCMAKE_INSTALL_PREFIX=%INSTPATH% ^
 -DCMAKE_BUILD_TYPE="Release" ^
 -DBOOST_ROOT=%DEPLIBS_DIR%\%BOOST_VER% ^
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

