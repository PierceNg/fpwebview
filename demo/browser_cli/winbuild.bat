@echo off

echo Set up FPC executable path.
set fpcexe=c:fpc.exe
if not exist "%fpcexe%" (
	echo ERROR: Edit this batch file to set up location of fpc.exe
	exit /b 1
)
echo "%fpcexe%"

echo Building...
copy "..\..\dll\x86_64\libwebview.a" .
copy "..\..\dll\x86_64\webview.dll" .
copy "..\..\dll\x86_64\WebView2Loader.dll" .
"%fpcexe%" -Fu..\..\src -Fl. browser_cli.lpr

