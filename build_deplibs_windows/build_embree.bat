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

REM Compiler (win_cc.bat): clang-cl by default, DEPLIBS_WIN_CC=cl for MSVC
call "%~dp0win_cc.bat"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source (no source asset for v4.4.1; use auto-generated archive)
wget --content-disposition -c --progress=dot:mega -O embree-%EMBREE_VER%.tar.gz ^
     https://github.com/RenderKit/embree/archive/refs/tags/v%EMBREE_VER%.tar.gz
7z x embree-%EMBREE_VER%.tar.gz -so | 7z x -si -ttar
cd embree-%EMBREE_VER%

REM clang-cl + Ninja: make Embree use its clang flags (see patch_embree_clang.cmake)
if /I "%DEPLIBS_WIN_CC%"=="clang-cl" (
  cmake -DEMBREE_SRC="%CD%" -P "%~dp0patch_embree_clang.cmake"
  if ERRORLEVEL 1 exit /b 1
)

SET INSTPATH=%BASEDIR%\embree-%EMBREE_VER%
SET TBB_INSTPATH=%BASEDIR%\tbb-%TBB_VER%
echo INSTPATH: %INSTPATH%

REM MAX_ISA is the highest ISA compiled in: Embree builds SSE2..AVX2 kernels and
REM picks one at run time, so the CPU floor stays SSE2.
REM Static Embree with TBB tasking. EMBREE_INSTALL_DEPENDENCIES=OFF is required for a
REM static TBB. TBB_DIR points at the cmake config dir, not the install root.
rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  %DEPLIBS_CC_OPT% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DEMBREE_STATIC_LIB=ON ^
  -DEMBREE_TASKING_SYSTEM=TBB ^
  -DEMBREE_TBB_ROOT="%TBB_INSTPATH%" ^
  -DTBB_DIR="%TBB_INSTPATH%\lib\cmake\TBB" ^
  -DEMBREE_INSTALL_DEPENDENCIES=OFF ^
  -DEMBREE_ISPC_SUPPORT=OFF ^
  -DEMBREE_TUTORIALS=OFF ^
  -DEMBREE_MAX_ISA=AVX2 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rd /s /q %INSTPATH%
cmake --install build

dir %INSTPATH%

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
