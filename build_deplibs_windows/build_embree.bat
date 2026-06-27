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

REM Centralized versions (skip # comment lines)
for /f "usebackq eol=# tokens=1,2 delims==" %%a in ("%~dp0..\deplibs.env") do set "%%a=%%b"

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source (no source asset for v4.4.1; use auto-generated archive)
wget --content-disposition -c --progress=dot:mega -O embree-%EMBREE_VER%.tar.gz ^
     https://github.com/RenderKit/embree/archive/refs/tags/v%EMBREE_VER%.tar.gz
7z x embree-%EMBREE_VER%.tar.gz -so | 7z x -si -ttar
cd embree-%EMBREE_VER%

SET INSTPATH=%BASEDIR%\embree-%EMBREE_VER%
SET TBB_INSTPATH=%BASEDIR%\tbb-%TBB_VER%
echo INSTPATH: %INSTPATH%

REM Static Embree with TBB tasking. EMBREE_INSTALL_DEPENDENCIES=OFF is required for a
REM static TBB. TBB_DIR points at the cmake config dir, not the install root.
rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DEMBREE_STATIC_LIB=ON ^
  -DEMBREE_TASKING_SYSTEM=TBB ^
  -DEMBREE_TBB_ROOT="%TBB_INSTPATH%" ^
  -DTBB_DIR="%TBB_INSTPATH%\lib\cmake\TBB" ^
  -DEMBREE_INSTALL_DEPENDENCIES=OFF ^
  -DEMBREE_ISPC_SUPPORT=OFF ^
  -DEMBREE_TUTORIALS=OFF ^
  -DEMBREE_MAX_ISA=SSE2 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build

rd /s /q %INSTPATH%
cmake --install build

dir %INSTPATH%

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
