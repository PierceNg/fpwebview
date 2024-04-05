#!/bin/sh
cp -p ../../dll/`uname -m`/libwebview.dylib .
fpc -Fu../../src -Fl. js_bidir.lpr
