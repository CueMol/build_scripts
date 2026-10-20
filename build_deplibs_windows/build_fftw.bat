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

SET INSTPATH=%BASEDIR%\fftw-%FFTW_VER%
echo INSTPATH: %INSTPATH%

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source
wget --content-disposition -c --progress=dot:mega ^
     https://www.fftw.org/fftw-%FFTW_VER%.tar.gz
REM tar xzf fftw-%FFTW_VER%.tar.gz
7z x fftw-%FFTW_VER%.tar.gz -so | 7z x -si -ttar
cd fftw-%FFTW_VER%

REM Upstream bug: /bigobj is passed as a define (see patch_fftw_bigobj.cmake)
cmake -DFFTW_SRC="%CD%" -P "%~dp0patch_fftw_bigobj.cmake"
if ERRORLEVEL 1 exit /b 1

REM Build
rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  %DEPLIBS_CC_OPT% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DENABLE_FLOAT=ON ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rd /s /q %INSTPATH%
cmake --install build

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
