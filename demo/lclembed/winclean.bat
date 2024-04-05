@echo off
echo Cleaning...
set FPWV_TARGET=lclembed
del %FPWV_TARGET%.exe
rmdir /s /q lib
del webview.lib
del webview.dll
del WebView2Loader.dll
del ..\..\src\webview.o
del ..\..\src\webview.ppu
