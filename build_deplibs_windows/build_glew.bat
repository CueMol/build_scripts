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

rem REM Get source
rem wget --content-disposition -c --progress=dot:mega ^
rem      https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
rem tar xzf glew-2.2.0.tgz
rem cd glew-2.2.0

rem msbuild build/vc15/glew_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64
rem REM /p:PlatformToolset=v143

REM Get binary
wget --content-disposition -c --progress=dot:mega ^
     https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0-win32.zip
unzip glew-2.2.0-win32.zip
cd glew-2.2.0

dir

REM #####

SET INSTPATH=%BASEDIR%\glew-2.2.0
echo INSTPATH: %INSTPATH%

mkdir %INSTPATH%\lib
dir lib\Release\x64
copy lib\Release\x64\glew32s.lib %INSTPATH%\lib\glew.lib

mkdir %INSTPATH%\include\GL
copy include\GL\*.h %INSTPATH%\include\GL\

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
