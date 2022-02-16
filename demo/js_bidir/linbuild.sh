#!/bin/sh
cp -p ../../dll/x86_64/libwebview.so .
fpc -Fu../../src -Fl. js_bidir.lpr
