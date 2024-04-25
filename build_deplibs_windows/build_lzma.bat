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

mkdir %TMPDIR%
cd %TMPDIR%

REM Get source
wget --content-disposition -c --progress=dot:mega ^
     https://github.com/tukaani-project/xz/releases/download/v5.2.12/xz-5.2.12.tar.xz
tar xJf xz-5.2.12.tar.xz
cd xz-5.2.12

REM Build
SET INSTPATH=%BASEDIR%\xz-5.2.12
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
