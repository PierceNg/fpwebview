program js_bidir;

{$linklib libwebview}

{$mode objfpc}{$H+}

uses
  {$ifdef unix}cthreads,{$endif}
  math,
  webview;

var
  w: PWebView;
  html: String;

procedure SayHello(const seq: PAnsiChar; const req: PAnsiChar; arg: Pointer); cdecl;
var
  s: String;
begin
  s := 'console.log("\nPascal calling back Javascript in Javascript-to-Pascal call ID ' + seq + '")';
  webview_eval(w, PAnsiChar(s));
  webview_return(w, seq, WebView_Return_Ok, '{result: "<p>Yo!</p>"}');
end;

begin
  { Set math masks. libwebview throws at least one of these from somewhere deep inside. }
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

  html := 'data:text/html,<html>' + LineEnding +
    '<head></head>' + LineEnding +
    '<body><button onClick="SayHello()">Say Hello</button>' + LineEnding +
    '<div id="greeting"></div>' + LineEnding +
    '<script>var SayHello = function() {' + LineEnding +
    '  HostSayHello().then((x) => document.getElementById("greeting").innerHTML = x.result)' + LineEnding +
    '}</script>' + LineEnding +
    '</body>' + LineEnding +
    '</html>';

  w := webview_create(WebView_DevTools, nil);
  webview_set_size(w, 700, 200, WebView_Hint_None);
  webview_set_title(w, PAnsiChar('WebView - Pascal Javascript Bidirectional'));
  webview_bind(w, PAnsiChar('HostSayHello'), @SayHello, nil);
  webview_navigate(w, PAnsiChar(html));
  webview_run(w);
  webview_destroy(w);
end.

