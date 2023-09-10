# https://aur.archlinux.org/cgit/aur.git/tree/toolchain-mingw.cmake?h=mingw-w64-cmake

set (CMAKE_SYSTEM_NAME Windows)
set (CMAKE_SYSTEM_PROCESSOR i686)

# specify the cross compiler
set (CMAKE_C_COMPILER i686-w64-mingw32-gcc)
set (CMAKE_CXX_COMPILER i686-w64-mingw32-g++)

# where is the target environment
set (CMAKE_FIND_ROOT_PATH /usr /usr/i686-w64-mingw32)

# search for programs in the build host directories
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Make sure Qt can be detected by CMake
set (QT_BINARY_DIR /usr/i686-w64-mingw32/bin /usr/bin)
set (QT_INCLUDE_DIRS_NO_SYSTEM ON)
set (QT_HOST_PATH "/usr" CACHE PATH "host path for Qt")

# set the resource compiler (RHBZ #652435)
set (CMAKE_RC_COMPILER i686-w64-mingw32-windres)
set (CMAKE_MC_COMPILER i686-w64-mingw32-windmc)

# override boost thread component suffix as mingw-w64-boost is compiled with threadapi=win32
set (Boost_THREADAPI win32)

# These are needed for compiling lapack (RHBZ #753906)
set (CMAKE_Fortran_COMPILER i686-w64-mingw32-gfortran)
set (CMAKE_AR:FILEPATH i686-w64-mingw32-ar)
set (CMAKE_RANLIB:FILEPATH i686-w64-mingw32-ranlib)

# https://aur.archlinux.org/cgit/aur.git/tree/toolchain-mingw-static.cmake?h=mingw-w64-cmake-static

# prefer static libraries
# note: It is of no use to set the real variable CMAKE_FIND_LIBRARY_SUFFIXES here because it gets overridden by CMake
#       after loading the toolchain file. The project needs to make the actual override if enforcing static libraries
#       is required.
set(CMAKE_FIND_LIBRARY_SUFFIXES_OVERRIDE ".a;.lib")
set(CMAKE_EXE_LINKER_FLAGS "$ENV{LDFLAGS} -static -static-libgcc -static-libstdc++" CACHE STRING "linker flags for static builds" FORCE)
