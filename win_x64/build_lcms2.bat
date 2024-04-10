REM wget https://github.com/mm2/Little-CMS/releases/download/lcms2.16/lcms2-2.16.tar.gz
REM tar xzf lcms2-2.16.tar.gz
REM cd lcms2-2.16
msbuild Projects\VC2022\lcms2_static\lcms2_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64
