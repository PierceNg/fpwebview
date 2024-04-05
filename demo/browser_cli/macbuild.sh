#!/bin/sh
cp -p ../../dll/`uname -m`/libwebview.dylib .
fpc -Fu../../src -Fl. browser_cli.lpr
