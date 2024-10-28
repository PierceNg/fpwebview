#!/bin/sh
cd lclembed.app/Contents/MacOS
rm -f lclembed
cp -p ../../../lclembed .
cp -p ../../../libwebview.dylib .
install_name_tool lclembed -change libwebview.dylib @executable_path/libwebview.dylib
cp -pr ../../../htdocs .
cp -p ../../../mime.types .
