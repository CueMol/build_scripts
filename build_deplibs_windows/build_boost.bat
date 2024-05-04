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

REM Get binary
wget --content-disposition -c --progress=dot:mega ^
     https://boost.teeks99.com/bin/1.84.0/boost_1_84_0-msvc-14.3-64.exe

boost_1_84_0-msvc-14.3-64.exe /?

