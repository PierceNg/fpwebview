unit guiform;

{$mode objfpc}{$H+}
{$ifdef darwin}
  {$modeswitch objectivec1}
{$endif}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLType, fphttpapp,
  {$ifdef darwin}
    {$ifdef lclcocoa}CocoaAll, CocoaWindows,{$endif}
  {$endif}
  webview;

type

	{ TForm1 }

  TForm1 = class(TForm)
    TopPanel: TPanel;
    WebPanel: TPanel;
    BtnWebViewSayHello: TButton;
    BtnLazSayHello: TButton;
    BtnExitProgram: TButton;
    Timer1: TTimer;
    procedure OnFormPaint(Sender: TObject);
    procedure OnFormResize(Sender: TObject);
    procedure OnFormShow(Sender: TObject);
    procedure OnFormShowTimer(Sender: TObject);
    procedure OnClickExitProgram(Sender: TObject);
    procedure OnClickLazSayHello(Sender: TObject);
    procedure OnClickWebViewSayHello(Sender: TObject);
  private
    wvHandle: PWebView;
    isExiting: Boolean;
    {$ifdef lclcocoa}
    mainWC: TCocoaWindowContentDocument;
    wvWin: NSWindow;
    wvWinMask: Integer;
    {$endif}
    procedure CreateWebView;
    procedure UpdateWebViewWindow;
  public
    property webviewHandle: PWebView read wvHandle;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure SayHello(const seq: PAnsiChar; const req: PAnsiChar; arg: Pointer); cdecl;
const
  s =
    'var dc = document.getElementById("demo-content");' +
    'var p = document.createElement("p");' +
    'p.innerHTML = "\"Yo again!\" asynchronously injected by Javascript";' +
    'dc.appendChild(p);';
begin
  if Form1.webviewHandle <> nil then
    begin
      webview_eval(Form1.webviewHandle, PAnsiChar(s));
      webview_return(Form1.webviewHandle, seq, WebView_Return_Ok, '{result: "<p>\"Yo!\" returned by Pascal</p>"}');
    end;
end;

procedure TForm1.OnFormPaint(Sender: TObject);
begin
  {$ifdef lclcocoa}UpdateWebViewWindow;{$endif}
  {$ifdef lclwin32}Forms.Application.ProcessMessages;{$endif}
end;

procedure TForm1.OnFormResize(Sender: TObject);
begin
  if wvHandle <> nil then
    webview_set_size(wvHandle, WebPanel.ClientWidth, WebPanel.ClientHeight, WebView_Hint_Fixed);
end;

procedure TForm1.OnFormShow(Sender: TObject);
begin
  Timer1.Interval := 1000;
  Timer1.Enabled := true;
end;

procedure TForm1.OnFormShowTimer(Sender: TObject);
begin
  Timer1.Enabled := false;
  if not isExiting then
    CreateWebView;
end;

procedure TForm1.OnClickExitProgram(Sender: TObject);
begin
  isExiting := true;
  if wvHandle <> nil then
    webview_terminate(wvHandle);
  Sleep(500);
  fphttpapp.Application.Terminate;
  if wvHandle <> nil then
    webview_destroy(wvHandle);
  wvHandle := nil;
  WebPanel.Hide;
  Halt;
end;

procedure TForm1.OnClickLazSayHello(Sender: TObject);
begin
  Forms.Application.MessageBox('This is Lazarus GUI component in action', 'fpwebview LCL Embedded Demo');
end;

procedure TForm1.OnClickWebViewSayHello(Sender: TObject);
const
  s =
    'var dc = document.getElementById("demo-content");' +
    'var p = document.createElement("p");' +
    'p.innerHTML = "Lazarus says \"Yo!\"";' +
    'dc.appendChild(p);';
begin
  webview_eval(Form1.webviewHandle, PAnsiChar(s));
end;

procedure TForm1.CreateWebView;
var
  phwnd: HWND;
  {$ifdef lclcocoa}
  aWC: TCocoaWindowContentDocument;
  aRect: NSRect;
  aView: NSView;
  {$endif}
begin
  if wvHandle <> nil then
    exit;
  WebPanel.HandleNeeded;
  phwnd := WebPanel.Handle;

  {$ifdef lclwin32}
  wvHandle := webview_create(WebView_DevTools, @phwnd);
  {$endif}
  {$ifdef lclcocoa}
  mainWC := TCocoaWindowContentDocument(self.Handle);
  aRect.origin := mainWC.window.frame.origin;
  aRect.size.width := WebPanel.ClientWidth;
  aRect.size.height := WebPanel.ClientHeight;
  aView := NSView.alloc.initWithFrame(aRect);
  aWC := TCocoaWindowContentDocument(phwnd);
  aWC.addSubView(aView);
  wvWinMask := NSBorderlessWindowMask or NSFullSizeContentViewWindowMask;
  wvWin := NSWindow.alloc.initWithContentRect_styleMask_backing_defer(
    aRect,
    wvWinMask,
    NSBackingStoreBuffered,
    false);
  wvWin.setContentView(aView);
  wvHandle := webview_create(WebView_DevTools, Pointer(wvWin));
  mainWC.window.addChildWindow_ordered(wvWin, NSWindowAbove);
  {$endif}

  // Should check wvHandle <> nil
  webview_bind(wvHandle, PAnsiChar('HostSayHello'), @SayHello, nil);
  webview_navigate(wvHandle, PAnsiChar('http://localhost:8000/'));
  webview_run(wvHandle);
end;

procedure TForm1.UpdateWebViewWindow;
begin
  {$ifdef lclcocoa}
  if wvHandle <> nil then
    begin
      wvWin.setStyleMask(wvWinMask);
      wvWin.setFrameOrigin(mainWC.window.frame.origin);
		end;
  {$endif}
end;

end.

