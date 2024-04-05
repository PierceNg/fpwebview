program browser_cli;

{$ifdef darwin}{$linklib libwebview}{$endif}
{$ifdef mswindows}{$linklib libimpwebview}{$endif}

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

