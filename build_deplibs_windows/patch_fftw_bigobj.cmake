# Fix FFTW 3.3.10 passing /bigobj as a preprocessor definition.
# Run with cmake -P, -DFFTW_SRC=<fftw source root>.
#
# CMakeLists.txt adds /bigobj with target_compile_definitions, so it reaches the
# compiler as -D/bigobj: MSVC cl silently ignores it, clang-cl rejects it
# ("macro name must be an identifier"). Pass it as a compile option instead.

set(f "${FFTW_SRC}/CMakeLists.txt")
file(READ "${f}" s)
set(old [=[target_compile_definitions (${fftw3_lib} PRIVATE /bigobj)]=])
set(new [=[target_compile_options (${fftw3_lib} PRIVATE /bigobj)]=])
string(FIND "${s}" "${old}" pos)
if(pos EQUAL -1)
  message(FATAL_ERROR "patch_fftw_bigobj: pattern not found in ${f}")
endif()
string(REPLACE "${old}" "${new}" s "${s}")
file(WRITE "${f}" "${s}")
message(STATUS "patch_fftw_bigobj: patched ${f}")
