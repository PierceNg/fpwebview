unit webview;

(*
 Copyright (c) 2022 Pierce Ng

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*)

{$mode objfpc}{$H+}

interface

type
  PWebView = type Pointer;
  TWebViewDispatchProc = procedure(w: PWebView; arg: Pointer); cdecl;
  TWebViewBindProc = procedure(const seq: PAnsiChar; const req: PAnsiChar; arg: Pointer); cdecl;

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
  WebView_Return_Ok = 0;
  WebView_Return_Error = 1;

function webview_create(debug: Integer; window: Pointer): PWebView; cdecl; external webview_lib;
procedure webview_destroy(w: PWebView); cdecl; external webview_lib;
procedure webview_run(w: PWebView); cdecl; external webview_lib;
procedure webview_terminate(w: PWebView); cdecl; external webview_lib;
procedure webview_dispatch(w: PWebView; fn: TWebViewDispatchProc; arg: Pointer); cdecl; external webview_lib;
function webview_get_window(w: PWebView): Pointer; cdecl; external webview_lib;
procedure webview_set_title(w: PWebView; const title: PAnsiChar); cdecl; external webview_lib;
procedure webview_set_size(w: PWebView; width, height, hints: Integer); cdecl; external webview_lib;
procedure webview_navigate(w: PWebView; const url: PAnsiChar); cdecl; external webview_lib;
procedure webview_set_html(w: PWebView; const html: PAnsiChar); cdecl; external webview_lib;
procedure webview_init(w: PWebView; const js: PAnsiChar); cdecl; external webview_lib;
procedure webview_eval(w: PWebView; const js: PAnsiChar); cdecl; external webview_lib;
procedure webview_bind(w: PWebView; const name: PAnsiChar; fn: TWebViewBindProc; arg: Pointer); cdecl; external webview_lib;
procedure webview_unbind(w: PWebView; const name: PAnsiChar); cdecl; external webview_lib;
procedure webview_return(w: PWebView; const seq: PAnsiChar; status: Integer; const result: PAnsiChar); cdecl; external webview_lib;

implementation

end.
