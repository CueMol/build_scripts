REM Windows compiler selection shared by the CMake-based deplib scripts.
REM Sets DEPLIBS_CC_OPT for the cmake configure command.
REM
REM   DEPLIBS_WIN_CC=clang-cl (default) -- clang-cl + lld-link
REM   DEPLIBS_WIN_CC=cl                 -- MSVC cl (the toolchain before clang-cl)
REM
REM Both need an x64 MSVC dev environment (vcvars): clang-cl targets the MSVC ABI
REM and uses its STL, CRT and Windows SDK, so the libraries stay link-compatible
REM with MSVC consumers. The CRT is left at the CMake default (/MD).

if "%DEPLIBS_WIN_CC%"=="" SET DEPLIBS_WIN_CC=clang-cl
if /I "%DEPLIBS_WIN_CC%"=="cl" (
  SET DEPLIBS_CC_OPT=-DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
) ELSE if /I "%DEPLIBS_WIN_CC%"=="clang-cl" (
  SET DEPLIBS_CC_OPT=-DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl -DCMAKE_LINKER=lld-link
) ELSE (
  echo Unknown DEPLIBS_WIN_CC: %DEPLIBS_WIN_CC% ^(expected clang-cl or cl^)
  exit /b 1
)
REM The vcvars env does not put LLVM on PATH; fall back to the default install
if /I "%DEPLIBS_WIN_CC%"=="clang-cl" (
  where clang-cl >NUL 2>&1 || SET "PATH=C:\Program Files\LLVM\bin;%PATH%"
)
REM where sets ERRORLEVEL when clang-cl is not on PATH; report success explicitly
exit /b 0
