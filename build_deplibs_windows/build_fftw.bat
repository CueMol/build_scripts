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

SET INSTPATH=%BASEDIR%\fftw-3.3.10
echo INSTPATH: %INSTPATH%

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source
wget --content-disposition -c --progress=dot:mega ^
     https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
cd fftw-3.3.10

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
