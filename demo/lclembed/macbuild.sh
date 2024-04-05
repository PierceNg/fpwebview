#!/bin/sh
cp -p ../../dll/`uname -m`/libwebview.dylib .
lazbuild lclembed.lpi

