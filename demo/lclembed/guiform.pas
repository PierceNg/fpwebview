unit guiform;

{$mode objfpc}{$H+}
{$ifdef darwin}
  {$modeswitch objectivec1}
{$endif}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLIntf, LCLType, fphttpapp,
  {$ifdef darwin}
    {$ifdef lclcocoa}CocoaAll, CocoaWindows,{$endif}
  {$endif}
  {$ifdef lclwin32}
  activex, windows,
  {$endif}
  webview;

{$ifdef lclwin32}
const
  WM_APP_ACTIVATE = WM_APP + 1;
{$endif}

type
  TForm1 = class(TForm)
    TopPanel: TPanel;
    WebPanel: TPanel;
    BtnWebViewSayHello: TButton;
    BtnLazSayHello: TButton;
    BtnExitProgram: TButton;
    Timer1: TTimer;
    procedure OnFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure OnFormCreate(Sender: TObject);
    procedure OnFormPaint(Sender: TObject);
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
    property WebPanelControl: TPanel read WebPanel;
    property WebviewHandle: PWebView read wvHandle;
  end;

var
  Form1: TForm1;
  {$ifdef lclwin32}
  ProxiedWndProc: WNDPROC;
  {$endif}

implementation

{$R *.lfm}

{$ifdef lclwin32}
function WebViewWndProc(aHwnd: HWND; uMsg: UInt; WParam: wParam; lParam: LParam): LRESULT; stdcall;
var
  r: RECTL;
  aWindow: HWND;
begin
  case uMsg of
    WM_APP_ACTIVATE, WM_SIZE:
        if Form1.WebViewHandle <> nil then
          begin
            Windows.GetClientRect(Form1.WebPanelControl.Handle, @r);
            aWindow := HWND(PtrUInt(webview_get_native_handle(Form1.WebViewHandle, UI_Widget)));
            MoveWindow(aWindow, r.top, r.left, r.right-r.left, r.bottom-r.top, true);
          end
    end;
  result := CallWindowProc(ProxiedWndProc, aHwnd, uMsg, wParam, lParam);
end;
{$endif}

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
      webview_return(Form1.webviewHandle, seq, WebView_Return_Ok, '{"result": "<p>\"Yo!\" returned by Pascal</p>"}');
    end;
end;

procedure TForm1.OnFormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
    OnClickExitProgram(Sender);
end;

procedure TForm1.OnFormCreate(Sender: TObject);
{$ifdef lclwin32}
var
  comInitStatus: HRESULT;
{$endif}
begin
  {$ifdef lclwin32}
  ProxiedWndProc := Windows.WNDPROC(SetWindowLongPtr(Self.Handle, GWL_WNDPROC, PtrUInt(@WebViewWndProc)));
  CoUninitialize;
  comInitStatus := CoInitializeEx(nil,  COINIT_APARTMENTTHREADED);
  if (comInitStatus <> S_OK) and (comInitStatus <> S_FALSE) then
    ShowMessage('webview COM init failed, program will not work correctly');
  {$endif}
end;

procedure TForm1.OnFormPaint(Sender: TObject);
begin
  {$ifdef lclcocoa}UpdateWebViewWindow;{$endif}
  {$ifdef lclwin32}Forms.Application.ProcessMessages;{$endif}
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
  Sleep(500);
  fphttpapp.Application.Terminate;
  if wvHandle <> nil then
    webview_destroy(wvHandle);
  WebPanel.Hide;
  {$ifdef lclwin32}
  CoUninitialize;
  {$endif}
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
  webview_eval(webviewHandle, PAnsiChar(s));
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
  wvWinMask := NSBorderlessWindowMask;
  wvWin := NSWindow.alloc.initWithContentRect_styleMask_backing_defer(
    aRect,
    wvWinMask,
    NSBackingStoreBuffered,
    false);
  //wvWin.setContentView(aView); // Done by libwebview.
  mainWC.window.addChildWindow_ordered(wvWin, NSWindowAbove);
  wvHandle := webview_create(WebView_DevTools, Pointer(wvWin));
  {$endif}

  if wvHandle <> nil then
    begin
      webview_bind(wvHandle, PAnsiChar('HostSayHello'), @SayHello, nil);
      webview_navigate(wvHandle, PAnsiChar('http://localhost:8000/'));
      {$ifdef lclwin32}
      PostMessage(Form1.Handle, WM_APP_ACTIVATE, 0, 0);
      {$endif}
      webview_run(wvHandle);
    end
  else
    ShowMessage('webview creation failed, program will not work correctly.');
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

