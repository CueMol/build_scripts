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

SET BOOST_VER=boost_1_84_0
REM Get source
wget --content-disposition -c --progress=dot:mega ^
     -O %BOOST_VER%.tar.bz2 ^
     https://sourceforge.net/projects/boost/files/boost/1.84.0/boost_1_84_0.tar.bz2/download
REM     https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.bz2

rd /s /q %BOOST_VER%
tar xjf %BOOST_VER%.tar.bz2
cd %BOOST_VER%

SET INST_PATH=%BASEDIR%\boost_1_84_0

cmd /c bootstrap.bat

b2 ^
 --prefix=%INST_PATH% ^
 --with-date_time ^
 --with-filesystem ^
 --with-iostreams ^
 --with-system ^
 --with-thread ^
 --with-chrono ^
 --with-timer ^
 -d0 ^
 link=shared threading=multi toolset=msvc address-model=64 install

dir %INST_PATH%

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%

