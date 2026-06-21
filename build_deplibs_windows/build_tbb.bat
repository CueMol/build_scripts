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

SET TBB_VER=2023.0.0

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source (auto-generated archive; release assets are prebuilt binaries, not source)
wget --content-disposition -c --progress=dot:mega -O oneTBB-%TBB_VER%.tar.gz ^
     https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v%TBB_VER%.tar.gz
7z x oneTBB-%TBB_VER%.tar.gz -so | 7z x -si -ttar
cd oneTBB-%TBB_VER%

SET INSTPATH=%BASEDIR%\tbb-%TBB_VER%
echo INSTPATH: %INSTPATH%

rd /s /q build
cmake -S . -B build ^
  -A x64 -T host=x64 ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DTBB_TEST=OFF ^
  -DTBB_STRICT=OFF ^
  -DTBB_INSTALL=ON ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release

dir %INSTPATH%

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
