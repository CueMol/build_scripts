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
     https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
tar xzf glew-2.2.0.tgz
cd glew-2.2.0

dir

msbuild build/vc14/glew_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143

REM #####

INSTPATH=%BASEDIR%\glew-2.2.0

mkdir %INSTPATH%\lib
copy lib\Release\x64\glew32s.lib $INSTPATH\lib\glew.lib

mkdir %INSTPATH%\include\GL
copy include\GL\*.h $INSTPATH\include\GL\

REM Cleanup
cd %BASEDIR%
rd /s /q %TMPDIR%
