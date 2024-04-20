SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\glew-2.2.0

REM wget --progress=dot:mega https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz

tar xzf glew-2.2.0.tgz
cd glew-2.2.0

msbuild build/vc14/glew_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143

md %INSTPATH%\lib\
copy lib\Release\x64\glew32s.lib %INSTPATH%\lib\glew.lib

md %INSTPATH%\include\GL\
copy include\GL\*.h %INSTPATH%\include\GL\

cd ..
