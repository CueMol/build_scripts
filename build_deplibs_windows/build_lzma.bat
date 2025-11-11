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

SET LZMA_VER=5.2.12

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source
wget --content-disposition -c --progress=dot:mega ^
     https://github.com/tukaani-project/xz/releases/download/v%LZMA_VER%/xz-%LZMA_VER%.tar.gz
tar xzf xz-%LZMA_VER%.tar.gz
cd xz-%LZMA_VER%

REM Build
SET INSTPATH=%BASEDIR%\xz-%LZMA_VER%
echo INSTPATH: %INSTPATH%

rd /s /q build
cmake -S . -B build ^
  -DBUILD_SHARED_LIBS=OFF ^
  -A x64 -T host=x64 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
