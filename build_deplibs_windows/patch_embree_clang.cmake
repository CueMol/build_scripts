# Make Embree pick its clang flags (common/cmake/clang.cmake) for clang-cl.
# Run with cmake -P from the Embree source root.
#
# On Windows, Embree selects clang.cmake only for the Visual Studio LLVM toolset
# and otherwise falls back to msvc.cmake, whose per-ISA flags are just
# /D__SSE4_2__ and friends. clang-cl needs the matching -msse4.2 / -mavx2 / ...
# for each ISA kernel, so with Ninja + clang-cl the SSE4.2 kernels fail to
# compile. Select clang.cmake for any Clang as well.

set(f "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt")
if(DEFINED EMBREE_SRC)
  set(f "${EMBREE_SRC}/CMakeLists.txt")
endif()
file(READ "${f}" s)
set(old [=[ELSEIF(${CMAKE_GENERATOR_TOOLSET} MATCHES "^LLVM")]=])
set(new [=[ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" OR "${CMAKE_GENERATOR_TOOLSET}" MATCHES "^LLVM")]=])
string(FIND "${s}" "${old}" pos)
if(pos EQUAL -1)
  message(FATAL_ERROR "patch_embree_clang: pattern not found in ${f}")
endif()
string(REPLACE "${old}" "${new}" s "${s}")
file(WRITE "${f}" "${s}")
message(STATUS "patch_embree_clang: patched ${f}")
