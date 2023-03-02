@echo off
echo Building using lazbuild
copy "..\..\dll\x86_64\libimpwebview.a" .
copy "..\..\dll\x86_64\webview.dll" .
copy "..\..\dll\x86_64\WebView2Loader.dll" .
lazbuild.exe lclembed.lpi
if errorlevel 1 (
	echo ERROR: not found lazbubild.exe
	echo ERROR: Edit this batch file to set up location of lazbuild.exe
)

