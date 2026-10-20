Administrator cmd
choco install wget unzip ninja

The CMake-based libraries (TBB, Embree, OIDN, CGAL, FFTW, LibLZMA) build with the
Ninja generator. TBB, Embree, OIDN, FFTW and LibLZMA use clang-cl + lld-link by
default (win_cc.bat; set DEPLIBS_WIN_CC=cl for MSVC cl). clang-cl targets the MSVC
ABI, so the bundle stays link-compatible with MSVC consumers; Boost (b2), lcms2
(vcxproj) and GLEW (prebuilt) stay MSVC-built. Run these from a "x64 Native Tools
Command Prompt" (or after vcvars64.bat) so the MSVC STL/SDK, cl.exe and ninja are
on PATH; clang-cl is taken from PATH or C:\Program Files\LLVM\bin. In CI this is
set up by ilammy/msvc-dev-cmd plus a pinned LLVM install.

Two upstream build issues are patched before configuring (cmake -P scripts here):
- patch_embree_clang.cmake: Embree selects its clang flags (per-ISA -msse4.2 /
  -mavx2 ...) only for the VS LLVM toolset; with Ninja + clang-cl it would use the
  MSVC flags and the SSE4.2 kernels fail to compile. Applied for clang-cl only.
- patch_fftw_bigobj.cmake: FFTW 3.3.10 passes /bigobj as a define (-D/bigobj),
  which MSVC ignores and clang-cl rejects. Applied for both compilers.

Embree is built with EMBREE_MAX_ISA=AVX2: kernels for SSE2..AVX2 are compiled and
one is picked at run time, so the CPU floor stays SSE2.

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

