#!/bin/sh

#  HaskellConfigVars.sh
#  HaskellSpriteKit
#
#  Created by Manuel M T Chakravarty on 21.09.16.
#  Copyright © 2016 Manuel M T Chakravarty.

# Set up variables for Haskell tools

if [ -d $SOURCE_ROOT/../BinaryFrameworks/$CONFIGURATION/GHC.Framework ];
then
GHC_FRAMEWORK_EXISTS=YES
else
GHC_FRAMEWORK_EXISTS=NO
fi

if [ $GHC_FRAMEWORK_EXISTS = "YES" ];
then
  # Compiled with GHC.framework (please don't change this)

  # We need to standardise these paths as they will end up in Haskell package config files.
  GHC_CURRENT_RAW=$SOURCE_ROOT/../BinaryFrameworks/$CONFIGURATION/GHC.Framework/Versions/Current
  STANDARDIZE=$GHC_CURRENT_RAW/Executables/StandardizePath.buildtime
  GHC_CURRENT="`$STANDARDIZE $GHC_CURRENT_RAW`"
  GHC=$GHC_CURRENT/usr/bin/ghc
  GHC_PKG=$GHC_CURRENT/usr/bin/ghc-pkg
  HADDOCK=$GHC_CURRENT/usr/bin/haddock
  CABAL=/Library/Haskell/bin/cabal
  GHC_VERSION=`$GHC --numeric-version`

  echo "GHC_CURRENT = $GHC_CURRENT"

  GHCLIB=$GHC_CURRENT/usr/lib/ghc-${GHC_VERSION}
  GHCSHARE=$GHC_CURRENT/usr/share
  GHCDOC=$GHCSHARE/doc/ghc

  GHC_OPTIONS="-optl-Wl,-headerpad_max_install_names"
  CABAL_PREFIX="--prefix=$GHCLIB"
  CABAL_DIRS="--bindir=$GHCLIB/bin --libdir=$GHCLIB --libexecdir=$GHCLIB/libexec --datadir=$GHCSHARE"
  CABAL_DOCDIRS="--docdir=$GHCDOC --htmldir=$GHCDOC/html/libraries/$PKG --haddockdir=$GHCDOC/html/libraries/$PKG"
  CABAL_OPTIONS="--package-db=$GHCLIB/package.conf.d --disable-library-vanilla"

else
  # Standalone setup (feel free to improve)

  GHC="`which ghc`"
  GHC_PKG="`which ghc-pkg`"
  CABAL="`which cabal`"
  HADDOCK="`which haddock`"
  GHC_VERSION=`$GHC --numeric-version`
  GHCLIB="`$GHC --print-libdir`"
  GHCSHARE=$GHCLIB/../../share
  GHCDOC=$GHCSHARE/doc/ghc

  GHC_OPTIONS=""
  CABAL_PREFIX=""
  CABAL_DIRS=""
  CABAL_DOCDIRS=""
  CABAL_OPTIONS=""

fi

# Change Haskell SpriteKit version in the Build Settings ("Current Project Version")
echo "GHC version = $GHC_VERSION; Haskell SpriteKit version = $CURRENT_PROJECT_VERSION"
echo "GHC binary = $GHC"

PKG=spritekit-${CURRENT_PROJECT_VERSION}
