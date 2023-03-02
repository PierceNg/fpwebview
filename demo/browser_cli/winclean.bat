@echo off
echo Cleaning...
set FPWV_TARGET=browser_cli
del %FPWV_TARGET%.exe
del %FPWV_TARGET%.o
del libwebview.a
del libimpwebview.a
del webview.dll
del WebView2Loader.dll
del ..\..\src\webview.o
del ..\..\src\webview.ppu

