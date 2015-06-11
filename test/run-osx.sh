#!/bin/sh

if [ -z "$GTEST_ROOT" ]; then
  echo "GTEST_ROOT MUST BE DEFINED!"
  exit -1  
fi

INSTALL_PREFIX="osx"

OSX_DEPLOYMENT_TARGET=10.7
OSX_ARCHS="x86_64"

# ---

BUILD_DIR="build/$INSTALL_PREFIX"
INSTALL_PATH="../../bin/$INSTALL_PREFIX"
TOOLCHAIN_FILE="$GTEST_ROOT/cmake/osx.cmake"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DEXECUTABLE_OUTPUT_PATH="$INSTALL_PATH" \
  -DCMAKE_PREFIX_PATH="$GTEST_ROOT" \
  -DCMAKE_LIBRARY_ARCHITECTURE="$INSTALL_PREFIX" \
  -DOSX_DEPLOYMENT_TARGET=$OSX_DEPLOYMENT_TARGET \
  -DOSX_ARCHS="$OSX_ARCHS" \
  -DCMAKE_BUILD_TYPE=Release \
  ../..

if (( $? )) ; then
  echo "cmake FAILED!"
  exit -1
fi

# ---

HOST_NUM_CPUS=$(sysctl hw.ncpu | awk '{print $2}')
make VERBOSE=1 -j$HOST_NUM_CPUS

if (( $? )) ; then
  echo "make FAILED!"
  exit -1
fi

# ---

PROJECT_NAME="HelloGTest"

cd "$INSTALL_PATH"
./$PROJECT_NAME
