program servcli;

{$ifdef darwin}{$linklib libwebview}{$endif}
{$ifdef mswindows}{$linklib libwebview}{$endif}
{$mode objfpc}{$H+}

{$macro on}
{$define nl:= + LineEnding +}

uses
  {$ifdef unix}cmem, cthreads,{$endif}
  math, webview,
  classes, fphttpapp, fpwebfile;

type
  TWebServerThread = class(TThread)
    protected
      procedure Execute; override;
    public
      constructor Create(CreateSuspended: boolean);
  end;

constructor TWebServerThread.Create(CreateSuspended: boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
end;

procedure TWebServerThread.Execute;
begin
  Application.Run;
end;

var
  currDir: String;
  w: PWebView;

procedure SayHello(const seq: PAnsiChar; const req: PAnsiChar; arg: Pointer); cdecl;
const
  s =
    'var dc = document.getElementById("demo-content")'nl
    'var p = document.createElement("p")'nl
    'p.innerHTML = "\"Yo again!\" asynchronously injected"'nl
    'dc.appendChild(p)';
begin
  webview_eval(w, PAnsiChar(s));
  webview_return(w, seq, WebView_Return_Ok, '{result: "<p>\"Yo!\" returned by Pascal</p>"}');
end;

procedure AppExit(const seq: PAnsiChar; const req: PAnsiChar; arg: Pointer); cdecl;
begin
  webview_terminate(w);
end;

begin
  { Set math masks. libwebview throws at least one of these from somewhere deep inside. }
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

  GetDir(0, currDir);
  TSimpleFileModule.BaseDir := currDir + '/htdocs';
  TSimpleFileModule.RegisterDefaultRoute;
  TSimpleFileModule.IndexPageName := 'index.html';
  MimeTypesFile := 'mime.types';
  Application.Port := 8000;
  Application.Threaded := true;
  Application.Title := 'fpwebview Embedded Web Server';
  Application.Initialize;
  TWebServerThread.Create(false);

  w := webview_create(WebView_DevTools, nil);
  webview_set_size(w, 1280, 720, WebView_Hint_None);
  webview_set_title(w, PAnsiChar('fpwebview - Embedded Web Server Demo'));
  webview_bind(w, PAnsiChar('HostSayHello'), @SayHello, nil);
  webview_bind(w, PAnsiChar('HostExit'), @AppExit, nil);
  webview_navigate(w, PAnsiChar('http://localhost:8000/'));
  webview_run(w);
  webview_destroy(w);
end.
