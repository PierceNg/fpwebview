@echo off
echo Building...
copy "..\..\dll\x86_64\webview.lib" .
copy "..\..\dll\x86_64\webview.dll" .
copy "..\..\dll\x86_64\WebView2Loader.dll" .
fpc.exe -Twin64 -Px86_64 -Fu..\..\src -Fl. servcli.lpr
if errorlevel 1 (
	echo ERROR: not found fpc.exe
	echo ERROR: Edit this batch file to set up location of fpc.exe
)

