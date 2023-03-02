@echo off
echo Cleaning...
set FPWV_TARGET=lclembed
del %FPWV_TARGET%.exe
rmdir /s /q lib\x86_64-win64
del libwebview.a
del libimpwebview.a
del webview.dll
del WebView2Loader.dll
del ..\..\src\webview.o
del ..\..\src\webview.ppu
