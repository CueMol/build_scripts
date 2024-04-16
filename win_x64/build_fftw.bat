SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\fftw-3.3.10

REM wget -c https://www.fftw.org/fftw-3.3.10.tar.gz
REM tar xzf lcms2-2.16.tar.gz
REM cd lcms2-2.16

echo "DEPLIBS_DIR: " %DEPLIBS_DIR%

rd /s /q build

cmake -S . -B build ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DENABLE_FLOAT=ON ^
  -A x64 -T host=x64 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"
   
cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release
