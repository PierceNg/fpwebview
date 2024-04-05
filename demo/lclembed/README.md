# lclembed

This is a demo of *embedding* webview in a desktop Lazarus GUI application.

![fpwebview embedded in Lazarus Cocoa app demo](/screenshot/cocoawebview.jpg?raw=true "fpwebview LCL GUI")

In the screenshot, the three buttons above the web content are outside of the webview
display area, and are Lazarus components making up the GUI application. The 'Say Yo To
Webview' button demonstrates updating content shown by webview in response to GUI
action, while the 'Lazarus Say Hello' button demonstrates standard GUI functionality.

Technically, this application demonstrates concurrent execution of the Lazarus GUI event
loop managing the application's windows, and webview's own event loop that manages
the Lazarus window in which webview is embedded.

The demo works on macOS (using Lazarus Cocoa widget set) and Windows (using Lazarus
Windows widget set).

For Linux:

- with Lazarus GTK2: Impossible, as GTK2 and GTK3 (which webview on Linux uses)
  cannot run as one executable.

- with Lazarus GTK3: Should be trivial. Note that at present Lazarus GTK3 is
  work-in-progress and not mature.

- with Lazarus Qt5/Qt6: Possible, potentially tricky. The basic requirement is to convert
  a Qt window handle into a GTK3 window suitable for use with webview.

