#!/bin/sh
cp -p ../../dll/x86_64/libwebview.dylib .
fpc -Fu../../src -Fl. js_eval.lpr
