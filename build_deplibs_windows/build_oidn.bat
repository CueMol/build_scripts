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

REM ISPC: build-time-only compiler for OIDN's CPU kernels. Fetch a prebuilt binary
REM into TMPDIR (removed before packaging, so it never lands in the tarball).
wget --content-disposition -c --progress=dot:mega -O ispc-v%ISPC_VER%-windows.zip ^
     https://github.com/ispc/ispc/releases/download/v%ISPC_VER%/ispc-v%ISPC_VER%-windows.zip
7z x ispc-v%ISPC_VER%-windows.zip
SET ISPC_BIN=%TMPDIR%\ispc-v%ISPC_VER%-windows\bin\ispc.exe

REM OIDN source: use the official source release asset (weights are bundled, so no
REM Git LFS is needed). The auto-generated GitHub archive would ship broken LFS
REM pointer files instead of the model weights.
wget --content-disposition -c --progress=dot:mega -O oidn-%OIDN_VER%.src.tar.gz ^
     https://github.com/RenderKit/oidn/releases/download/v%OIDN_VER%/oidn-%OIDN_VER%.src.tar.gz
7z x oidn-%OIDN_VER%.src.tar.gz -so | 7z x -si -ttar
cd oidn-%OIDN_VER%

SET INSTPATH=%BASEDIR%\oidn-%OIDN_VER%
SET TBB_INSTPATH=%BASEDIR%\tbb-%TBB_VER%
echo INSTPATH: %INSTPATH%

REM CPU-only static OIDN with TBB tasking. GPU devices are all OFF so
REM OIDN_STATIC_LIB yields a fully static library. ISA is left at the default.
REM TBB_DIR points at the cmake config dir, not the install root.
rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DOIDN_STATIC_LIB=ON ^
  -DOIDN_DEVICE_CPU=ON ^
  -DOIDN_DEVICE_SYCL=OFF ^
  -DOIDN_DEVICE_CUDA=OFF ^
  -DOIDN_DEVICE_HIP=OFF ^
  -DOIDN_DEVICE_METAL=OFF ^
  -DOIDN_APPS=OFF ^
  -DOIDN_FILTER_RT=ON ^
  -DOIDN_FILTER_RTLIGHTMAP=OFF ^
  -DISPC_EXECUTABLE="%ISPC_BIN%" ^
  -DTBB_ROOT="%TBB_INSTPATH%" ^
  -DTBB_DIR="%TBB_INSTPATH%\lib\cmake\TBB" ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build

rd /s /q %INSTPATH%
cmake --install build

dir %INSTPATH%

REM Cleanup (also removes the build-time-only ISPC under TMPDIR)
cd %BASEDIR%
rd /s /q %TMPDIR%
