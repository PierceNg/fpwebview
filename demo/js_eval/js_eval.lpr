program js_eval;

{$ifdef darwin}{$linklib libwebview}{$endif}
{$ifdef mswindows}{$linklib libimpwebview}{$endif}

{$mode objfpc}{$H+}

uses
  {$ifdef unix}cthreads,{$endif}
  math,
  webview;

var
  w: PWebView;
  js: String;

begin
  { Set math masks. libwebview throws at least one of these from somewhere deep inside. }
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

  js := 'document.addEventListener("DOMContentLoaded", () => {' + LineEnding +
    'var h1 = document.createElement("h1");' + LineEnding +
    'h1.innerHTML = "Hello, webview, from Pascal!";' + LineEnding +
    'document.body.appendChild(h1);' + LineEnding +
    '})';

  w := webview_create(WebView_DevTools, nil);
  webview_set_size(w, 700, 200, WebView_Hint_None);
  webview_set_title(w, PAnsiChar('WebView - Pascal calling Javascript'));
  webview_set_html(w, PAnsiChar('<html><head></head><body></body></html>'));
  webview_init(w, PAnsiChar(js));
  webview_run(w);
  webview_destroy(w);
end.

