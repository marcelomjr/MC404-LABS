#!/bin/sh

set -x

AUX_DIR=build-aux

test -d $AUX_DIR || mkdir -p $AUX_DIR

aclocal
autoconf
automake --add-missing
