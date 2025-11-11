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

SET FFTW_VER=3.3.10

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
  -DBUILD_SHARED_LIBS=OFF ^
  -DENABLE_FLOAT=ON ^
  -A x64 -T host=x64 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"

cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
