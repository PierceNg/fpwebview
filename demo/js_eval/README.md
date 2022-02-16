# Linux

Tested working on Ubuntu 20.04.

# macOS

Tested working on macOS Catalina.

# Windows 10

On my (Pierce Ng's) Windows 10 Home 20H2, the webview window comes up
blank. With a ```sleep()``` statement between invocation of
```webview_navigate()``` and ```webview_eval()```, the Javascript-injected
content shows up, and is then *replaced* by the content injected by
```webview_navigate()```. 

In conclusion, as a Pascal program invoking ```webview.dll```, this program
works, but its behaviour, driven by the Windows web engine's execution
model, is unexpected.  Better to use the bidirectional functionality demonstrated
by ```js_bidir.lpr```.

