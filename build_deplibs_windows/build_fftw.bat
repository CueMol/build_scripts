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

REM Build
rd /s /q build
cmake -S . -B build ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DENABLE_FLOAT=ON ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build

rd /s /q %INSTPATH%
cmake --install build

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
