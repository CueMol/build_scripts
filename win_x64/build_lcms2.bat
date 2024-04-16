SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\lcms2-2.16

REM wget https://github.com/mm2/Little-CMS/releases/download/lcms2.16/lcms2-2.16.tar.gz
REM tar xzf lcms2-2.16.tar.gz
REM cd lcms2-2.16
msbuild Projects\VC2022\lcms2_static\lcms2_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64

md %INSTPATH%\lib\
copy Lib\MS\lcms2_static.lib %INSTPATH%\lib\lcms2.lib

md %INSTPATH%\include\
copy include\*.h %INSTPATH%\include\
