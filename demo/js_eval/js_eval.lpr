program js_eval;

{$linklib libwebview}

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

  js := 'var h1 = document.createElement("h1")' + LineEnding +
    'h1.innerHTML = "Hello, webview, from Pascal!"' + LineEnding +
    'document.body.appendChild(h1)';

  w := webview_create(WebView_DevTools, nil);
  webview_set_size(w, 700, 200, WebView_Hint_None);
  webview_set_title(w, PAnsiChar('WebView - Pascal calling Javascript'));
  webview_eval(w, PAnsiChar(js));
  webview_run(w);
  webview_destroy(w);
end.

