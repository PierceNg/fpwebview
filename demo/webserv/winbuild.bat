@echo off

echo Set up FPC executable path.
set fpcexe=c:\pkg\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe
if not exist "%fpcexe%" (
	echo ERROR: not found "%fpcexe"
	echo ERROR: Edit this batch file to set up location of fpc.exe
	exit /b 1
)
echo "%fpcexe%"

echo Building...
copy "..\..\dll\x86_64\libwebview.a" .
copy "..\..\dll\x86_64\webview.dll" .
copy "..\..\dll\x86_64\WebView2Loader.dll" .
"%fpcexe%" -Fu..\..\src -Fl. servcli.lpr

