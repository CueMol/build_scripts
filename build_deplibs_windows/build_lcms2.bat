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
     https://github.com/mm2/Little-CMS/releases/download/lcms2.16/lcms2-2.16.tar.gz
tar xzf lcms2-2.16.tar.gz
cd lcms2-2.16

REM Build
SET INSTPATH=%BASEDIR%\lcms2-2.16
echo INSTPATH: %INSTPATH%

msbuild Projects\VC2022\lcms2_static\lcms2_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64

md %INSTPATH%\lib\
copy Lib\MS\lcms2_static.lib %INSTPATH%\lib\lcms2.lib

md %INSTPATH%\include\
copy include\*.h %INSTPATH%\include\

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
