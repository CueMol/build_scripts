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

REM Get source
wget --content-disposition -c --progress=dot:mega ^
     https://github.com/tukaani-project/xz/releases/download/v%LZMA_VER%/xz-%LZMA_VER%.tar.gz
REM tar xzf xz-%LZMA_VER%.tar.gz
7z x xz-%LZMA_VER%.tar.gz -so | 7z x -si -ttar
cd xz-%LZMA_VER%

REM Build
SET INSTPATH=%BASEDIR%\xz-%LZMA_VER%
echo INSTPATH: %INSTPATH%

rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build

rd /s /q %INSTPATH%
cmake --install build

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
