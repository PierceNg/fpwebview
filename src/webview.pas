{
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
}

unit webview;

{$mode objfpc}{$H+}

interface

type
  PWebView = Pointer;
  TWebViewDispatchProc = procedure(w: PWebView; arg: Pointer); cdecl;

const
{$ifdef mswindows}
  webview_lib = 'webview.dll';
{$endif}
{$ifdef unix}
  {$ifdef darwin}
  webview_lib = 'libwebview.dylib';
  {$else}
  webview_lib = 'libwebview.so';
  {$endif}
{$endif}

const
  WebView_NoDevTools = 0;
  WebView_DevTools = 1;
  WebView_Hint_None = 0;
  WebView_Hint_Min = 1;
  WebView_Hint_Max = 2;
  WebView_Hint_Fixed = 3;

function webview_create(debug: Integer; window: Pointer): PWebView; cdecl; external webview_lib;
procedure webview_destroy(w: PWebView); cdecl; external webview_lib;
procedure webview_set_size(w: PWebView; width, height, hints: Integer); cdecl; external webview_lib;
procedure webview_set_title(w: PWebView; const title: PAnsiChar); cdecl; external webview_lib;
procedure webview_navigate(w: PWebView; const url: PAnsiChar); cdecl; external webview_lib;
procedure webview_dispatch(w: PWebView; fn: TWebViewDispatchProc; arg: Pointer); cdecl; external webview_lib;
procedure webview_run(w: PWebView); cdecl; external webview_lib;
procedure webview_terminate(w: PWebView); cdecl; external webview_lib;

implementation

end.
