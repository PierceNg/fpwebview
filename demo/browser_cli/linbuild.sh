#!/bin/sh
cp -p ../../dll/x86_64/libwebview.so .
fpc -Fu../../src -Fl. browser_cli.lpr
