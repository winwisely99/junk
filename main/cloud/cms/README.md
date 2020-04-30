# cms

We can kill many birds with one stone by using a CMS base
- Layer 1 can then be 100% web based and so then auth can be too.
- Website and docs can use it.
- go-admin is admin web ui for it
- buttercms is a flutter cms

## Server
https://github.com/GoAdminGroup/go-admin
- can make this replace butter cms ?

## Clients
buttercsm 
https://github.com/ButterCMS/buttercms-hugo
https://github.com/ButterCMS/buttercms-go
https://github.com/ButterCMS/buttercms-dart

Its nice and simple, and when we get a html page we can render it in a webview.
This makes sense because for Layer 1 its highly dynamic AND we need Webview anyway because of oAth2 needing it.
https://pub.dev/packages/easy_web_view
- used by https://pub.dev/packages/easy_google_maps