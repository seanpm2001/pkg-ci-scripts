#!/usr/bin/env bash
#
# DO NOT EDIT THIS FILE!
#
# If you have any questions about this script, or think it is not general
# enough to cover your use case (i.e., you feel that you need to modify it
# anyway), please contact Max Horn <max.horn@math.uni-giessen.de>.
#
set -ex

# ensure coverage is turned on
export CFLAGS="$CFLAGS --coverage"
export CXXFLAGS="$CXXFLAGS --coverage"
export LDFLAGS="$LDFLAGS --coverage"

# adjust build flags for 32bit builds
if [[ $ABI = 32 ]]; then
    export CFLAGS="$CFLAGS -m32"
    export CXXFLAGS="$CXXFLAGS -m32"
    export LDFLAGS="$LDFLAGS -m32"
fi

# build this package, if necessary
if [[ -x autogen.sh ]]; then
    ./autogen.sh
    ./configure --with-gaproot=$GAPROOT
    make -j4 V=1
elif [[ -x configure ]]; then
    ./configure $GAPROOT
    make -j4
fi

# set up a custom GAP root containing only this package, so that
# we can force GAP to load the correct version of this package
mkdir -p gaproot/pkg/
ln -s $PWD gaproot/pkg/
