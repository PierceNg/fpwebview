@echo off
echo Building...
copy "..\..\dll\i386\webview.lib" .
copy "..\..\dll\i386\webview.dll" .
copy "..\..\dll\i386\WebView2Loader.dll" .
lazbuild.exe --cpu=i386 --os=win32 lclembed.lpi
if errorlevel 1 (
	echo ERROR: not found lazbuild.exe
	echo ERROR: Edit this batch file to set up location of lazbuild.exe
)




