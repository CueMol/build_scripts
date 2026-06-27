Administrator cmd
choco install wget unzip ninja

The CMake-based libraries (TBB, Embree, OIDN, CGAL, FFTW, LibLZMA) build with the
Ninja generator and MSVC, so run these from a "x64 Native Tools Command Prompt"
(or after vcvars64.bat) so cl.exe / ninja are on PATH. In CI this is set up by
ilammy/msvc-dev-cmd.

Boost
build_boost.bat <deplibs_dir> Windows X64

TBB
build_tbb.bat <deplibs_dir> Windows X64

Embree
build_embree.bat <deplibs_dir> Windows X64

OIDN
build_oidn.bat <deplibs_dir> Windows X64

FFTW
build_fftw.bat <deplibs_dir> Windows X64

LCMS2
build_lcms2.bat <deplibs_dir> Windows X64

LibLZMA
build_lzma.bat <deplibs_dir> Windows X64

GLEW
build_glew.bat <deplibs_dir> Windows X64

CGAL
build_cgal.bat <deplibs_dir> Windows X64

