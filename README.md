# fpwebview

*fpwebview* is Free Pascal binding for [webview](https://github.com/webview/webview).

## Demo

```pascal
program browser_cli;

{$linklib libwebview}

uses
  {$ifdef unix}cthreads,{$endif}
  math,
  webview;

var
  w: PWebView;

begin
  { Set math masks. libwebview throws at least one of these from somewhere deep inside. }
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

  writeln('Hello, webview, from Pascal!');
  w := webview_create(WebView_DevTools, nil);
  webview_set_size(w, 1024, 768, WebView_Hint_None);
  webview_set_title(w, PAnsiChar('WebView Free Pascal'));
  webview_navigate(w, PAnsiChar('https://www.freepascal.org/'));
  webview_run(w);
  webview_destroy(w);
  writeln('Goodbye, webview.');
end.
```

## Getting Started

Binary support files for x86_64 for Linux, macOS and Windows are provided
with this repo. See the files in the ```dll/x86_64``` folder.

### Linux

```
% git clone https://github.com/PierceNg/fpwebview
% cd fpwebview/demo/browser_cli
% ./linbuild.sh
<output>
% ./linrun.sh
```

### macOS

```
% git clone https://github.com/PierceNg/fpwebview
% cd fpwebview/demo/browser_cli
% ./macbuild.sh
<output>
% ./macrun.sh
```

### Windows

```
C:\> git clone https://github.com/PierceNg/fpwebview
C:\> cd fpwebview\demo\browser_cli
C:\fpwebview\demo\browser_cli> winbuild.bat
<output>
C:\fpwebview\demo\browser_cli> winrun.bat
```

## Licenses

This repo is under MIT license, with following exceptions:

- The source file(s) that make up the ```webview``` Pascal unit are licensed under MPLv2. 

- Microsoft's ```WebView2Loader.dll``` is distributed as per ```LICENSE.Microsoft```.


## Further Work

The demo program ```browser_cli``` implements a web browser that opens to
the Free Pascal website.

Demos planned:
- ~~Bi-directional Pascal-Javascript calls~~
- i18n
- embedded webserver

