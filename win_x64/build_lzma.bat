SET DEPLIBS_DIR=c:\proj64_deplibs
SET INSTPATH=%DEPLIBS_DIR%\xz-5.2.12

REM wget -c https://github.com/tukaani-project/xz/releases/download/v5.2.12/xz-5.2.12.tar.xz
REM tar xJvf xz-5.2.12.tar.xz
REM cd xz-5.2.12

echo "DEPLIBS_DIR: " %DEPLIBS_DIR%

rd /s /q build

cmake -S . -B build ^
  -DBUILD_SHARED_LIBS=ON ^
  -A x64 -T host=x64 ^
  -DCMAKE_INSTALL_PREFIX="%INSTPATH%"
   
cmake --build build --config Release

rd /s /q %INSTPATH%
cmake --install build --config Release
