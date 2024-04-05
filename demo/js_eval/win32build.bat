@echo off
echo Building...
copy "..\..\dll\i386\webview.lib" .
copy "..\..\dll\i386\webview.dll" .
copy "..\..\dll\i386\WebView2Loader.dll" .
fpc.exe -Twin32 -Pi386 -Fu..\..\src -Fl. js_eval.lpr
if errorlevel 1 (
	echo ERROR: not found fpc.exe
	echo ERROR: Edit this batch file to set up location of fpc.exe
)



